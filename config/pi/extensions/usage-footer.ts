/**
 * Usage footer + /usage command.
 *
 * Footer (TUI status bar):
 *   Line 1: ~/cwd (git branch) • session-name
 *   Line 2: S$<session cost> T$<today cost> <context%>/<window> (auto)
 *           right-aligned: <model> • <thinking level>
 *
 * /usage command: full stats across all sessions (session / today / this
 * week / this month / all time, daily breakdown, per-project), rendered in
 * the transcript as a durable entry that is NOT sent to the LLM.
 *
 * All dollar figures come from the per-message usage.cost.total records pi
 * writes into the session JSONL files under ~/.pi/agent/sessions.
 * Refreshed at most every 60s.
 */

import { readdirSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Box, Text, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const REFRESH_MS = 60_000;

function formatTokens(count: number): string {
	if (count < 1000) return String(count);
	if (count < 10_000) return `${(count / 1000).toFixed(1)}k`;
	if (count < 1_000_000) return `${Math.round(count / 1000)}k`;
	if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
	return `${Math.round(count / 1_000_000)}M`;
}

function formatCwd(cwd: string, home: string): string {
	return cwd.startsWith(home + "/") ? `~${cwd.slice(home.length)}` : cwd;
}

function fmtCost(cost: number): string {
	return `$${cost.toFixed(3)}`;
}

function localDateKey(epoch: number): string {
	const d = new Date(epoch);
	const m = `${d.getMonth() + 1}`.padStart(2, "0");
	const day = `${d.getDate()}`.padStart(2, "0");
	return `${d.getFullYear()}-${m}-${day}`;
}

interface FullStats {
	todayCost: number;
	weekCost: number;
	monthCost: number;
	allTimeCost: number;
	todayTokens: number;
	weekTokens: number;
	monthTokens: number;
	allTimeTokens: number;
	byDay: { date: string; cost: number }[];
	byProject: { name: string; cost: number }[];
}

function scanAllStats(): FullStats {
	const now = new Date();
	const today = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime();
	const monday = today - ((now.getDay() + 6) % 7) * 86_400_000;
	const month = new Date(now.getFullYear(), now.getMonth(), 1).getTime();

	const byDayMap = new Map<string, { cost: number; tokens: number }>();
	const byProjectMap = new Map<string, { cost: number; tokens: number }>();

	let todayCost = 0;
	let weekCost = 0;
	let monthCost = 0;
	let allCost = 0;
	let todayTok = 0;
	let weekTok = 0;
	let monthTok = 0;
	let allTok = 0;

	const root = join(homedir(), ".pi", "agent", "sessions");
	let projects: string[];
	try {
		projects = readdirSync(root);
	} catch {
		return emptyStats();
	}
	for (const project of projects) {
		let files: string[];
		try {
			files = readdirSync(join(root, project)).filter((f) => f.endsWith(".jsonl"));
		} catch {
			continue;
		}
		for (const file of files) {
			let text: string;
			try {
				text = readFileSync(join(root, project, file), "utf8");
			} catch {
				continue;
			}
			for (const line of text.split("\n")) {
				if (!line.includes('"usage"') || !line.includes('"timestamp"')) continue;
				let entry: {
					timestamp?: string;
					message?: { usage?: { cost?: { total?: number }; totalTokens?: number } };
				};
				try {
					entry = JSON.parse(line);
				} catch {
					continue;
				}
				const cost = entry.message?.usage?.cost?.total;
				const tokens = entry.message?.usage?.totalTokens;
				const ts = entry.timestamp;
				if (typeof cost !== "number" || cost <= 0 || typeof ts !== "string") continue;
				const epoch = Date.parse(ts);
				if (Number.isNaN(epoch)) continue;

				allCost += cost;
				allTok += tokens ?? 0;
				if (epoch >= today) {
					todayCost += cost;
					todayTok += tokens ?? 0;
				}
				if (epoch >= monday) {
					weekCost += cost;
					weekTok += tokens ?? 0;
				}
				if (epoch >= month) {
					monthCost += cost;
					monthTok += tokens ?? 0;
				}

				const dayKey = localDateKey(epoch);
				const day = byDayMap.get(dayKey) ?? { cost: 0, tokens: 0 };
				day.cost += cost;
				day.tokens += tokens ?? 0;
				byDayMap.set(dayKey, day);

				const projName = project.replace(/^--|--$/g, "");
				const proj = byProjectMap.get(projName) ?? { cost: 0, tokens: 0 };
				proj.cost += cost;
				proj.tokens += tokens ?? 0;
				byProjectMap.set(projName, proj);
			}
		}
	}

	const byDay = Array.from(byDayMap.entries())
		.map(([date, v]) => ({ date, cost: v.cost }))
		.sort((a, b) => (a.date < b.date ? 1 : -1));
	const byProject = Array.from(byProjectMap.entries())
		.map(([name, v]) => ({ name, cost: v.cost }))
		.sort((a, b) => b.cost - a.cost);

	return {
		todayCost,
		weekCost,
		monthCost,
		allTimeCost: allCost,
		todayTokens: todayTok,
		weekTokens: weekTok,
		monthTokens: monthTok,
		allTimeTokens: allTok,
		byDay,
		byProject,
	};
}

function emptyStats(): FullStats {
	return {
		todayCost: 0,
		weekCost: 0,
		monthCost: 0,
		allTimeCost: 0,
		todayTokens: 0,
		weekTokens: 0,
		monthTokens: 0,
		allTimeTokens: 0,
		byDay: [],
		byProject: [],
	};
}

function sessionUsage(ctx: {
	sessionManager: {
		getBranch(): { type: string; message?: { role?: string; usage?: { cost: { total: number }; totalTokens?: number } } }[];
	};
}): { cost: number; tokens: number } {
	let cost = 0;
	let tokens = 0;
	for (const e of ctx.sessionManager.getBranch()) {
		if (e.type === "message" && e.message?.role === "assistant") {
			const m = e.message as AssistantMessage;
			cost += m.usage.cost.total;
			tokens += m.usage.totalTokens ?? 0;
		}
	}
	return { cost, tokens };
}

interface UsageReportData {
	sessionCost: number;
	sessionTokens: number;
	stats: FullStats;
}

function buildUsageReport(d: UsageReportData, theme: { fg: (c: string, t: string) => string }): string {
	const pad = (s: string, n: number) => `${s}${" ".repeat(Math.max(1, n - s.length))}`;
	const row = (label: string, cost: number, tokens?: number) =>
		`  ${pad(label, 12)}${fmtCost(cost)}${tokens !== undefined ? ` (${formatTokens(tokens)} tok)` : ""}`;

	const lines: string[] = [];
	lines.push(theme.fg("accent", "Pi usage (cost, all sessions)"));
	lines.push("");
	lines.push(row("session", d.sessionCost, d.sessionTokens));
	lines.push(row("today", d.stats.todayCost, d.stats.todayTokens));
	lines.push(row("this week", d.stats.weekCost, d.stats.weekTokens));
	lines.push(row("this month", d.stats.monthCost, d.stats.monthTokens));
	lines.push(row("all time", d.stats.allTimeCost, d.stats.allTimeTokens));

	if (d.stats.byDay.length > 0) {
		lines.push("");
		lines.push(theme.fg("accent", "Daily breakdown:"));
		for (const day of d.stats.byDay) {
			lines.push(`  ${pad(day.date, 12)}${fmtCost(day.cost)}`);
		}
	}

	if (d.stats.byProject.length > 0) {
		lines.push("");
		lines.push(theme.fg("accent", "By project:"));
		for (const p of d.stats.byProject) {
			lines.push(`  ${pad(p.name, 45)}${fmtCost(p.cost)}`);
		}
	}

	return lines.join("\n");
}

export default function usageFooterExtension(pi: ExtensionAPI) {
	let stats = scanAllStats();
	let cacheAt = Date.now();
	let autoCompact = false;
	let timer: ReturnType<typeof setInterval> | undefined;

	try {
		const settings = JSON.parse(readFileSync(join(homedir(), ".pi", "agent", "settings.json"), "utf8"));
		autoCompact = Boolean(settings.compaction?.enabled);
	} catch {
		// keep default (no indicator)
	}

	// ---- /usage command: full stats as a durable transcript entry ----
	pi.registerEntryRenderer<UsageReportData>("usage-report", (entry, _opts, theme) => {
		const d = entry.data;
		const text = d ? buildUsageReport(d, theme) : "No usage data yet.";
		const box = new Box(1, 1);
		box.addChild(new Text(text, 0, 0));
		return box;
	});

	pi.registerCommand("usage", {
		description: "Show pi usage (cost) across all sessions: session, today, week, month, all time, daily breakdown, per-project",
		handler: async (_args, ctx) => {
			const fresh = scanAllStats();
			const session = sessionUsage(ctx);
			pi.appendEntry<UsageReportData>("usage-report", {
				sessionCost: session.cost,
				sessionTokens: session.tokens,
				stats: fresh,
			});
		},
	});

	// ---- footer: session + today cost ----
	pi.on("session_start", (_event, ctx) => {
		if (!ctx.hasUI || ctx.mode !== "tui") return;

		if (timer) clearInterval(timer);
		timer = undefined;

		stats = scanAllStats();
		cacheAt = Date.now();

		ctx.ui.setFooter((tui, theme, footerData) => {
			if (!timer) {
				timer = setInterval(() => tui.requestRender(), REFRESH_MS);
			}
			const unsubBranch = footerData.onBranchChange(() => tui.requestRender());

			return {
				dispose() {
					unsubBranch();
				},
				invalidate() {},
				render(width: number): string[] {
					if (Date.now() - cacheAt > REFRESH_MS) {
						stats = scanAllStats();
						cacheAt = Date.now();
					}

					// Session cost + model + thinking level from the in-memory branch.
					let sessionCost = 0;
					let modelId: string | undefined;
					let thinking: string | undefined;
					for (const e of ctx.sessionManager.getBranch()) {
						if (e.type === "message" && e.message.role === "assistant") {
							const m = e.message as AssistantMessage;
							sessionCost += m.usage.cost.total;
						} else if (e.type === "model_change") {
							modelId = e.modelId;
						} else if (e.type === "thinking_level_change") {
							thinking = e.thinkingLevel;
						}
					}

					// Line 1: cwd (branch) • session-name
					const branch = footerData.getGitBranch();
					let pwd = formatCwd(ctx.cwd, homedir());
					if (branch) pwd = `${pwd} (${branch})`;
					const sessionName = ctx.sessionManager.getSessionName();
					if (sessionName) pwd = `${pwd} • ${sessionName}`;

					// Line 2: session + today cost, then context usage
					const statsParts: string[] = [];
					statsParts.push(`S${fmtCost(sessionCost)}`);
					statsParts.push(`T${fmtCost(stats.todayCost)}`);

					const contextUsage = ctx.getContextUsage();
					const contextWindow = contextUsage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
					const percent = contextUsage?.percent;
					let contextDisplay: string;
					if (percent === null || percent === undefined) {
						contextDisplay = `?/${formatTokens(contextWindow)}`;
					} else {
						contextDisplay = `${percent.toFixed(1)}%/${formatTokens(contextWindow)}`;
					}
					if (autoCompact) contextDisplay += " (auto)";
					if (percent !== null && percent !== undefined) {
						if (percent > 90) contextDisplay = theme.fg("error", contextDisplay);
						else if (percent > 70) contextDisplay = theme.fg("warning", contextDisplay);
					}
					statsParts.push(contextDisplay);

					const statsLeft = statsParts.join(" ");

					// Right side: model • thinking level
					const modelName = modelId ?? ctx.model?.id ?? "no-model";
					let rightSide = modelName;
					const showThinking = thinking !== undefined || Boolean(ctx.model?.reasoning);
					if (showThinking) {
						rightSide = thinking === undefined
							? `${modelName} • thinking off`
							: `${modelName} • ${thinking}`;
					}

					// Layout: left stats, right-aligned model; truncate if needed.
					let statsLeftWidth = visibleWidth(statsLeft);
					if (statsLeftWidth > width) {
						statsLeft = truncateToWidth(statsLeft, width, "...");
						statsLeftWidth = visibleWidth(statsLeft);
					}
					const rightSideWidth = visibleWidth(rightSide);
					const minPadding = 2;
					const availableForRight = width - statsLeftWidth - minPadding;
					let statsLine: string;
					if (availableForRight > 0) {
						const truncatedRight = truncateToWidth(rightSide, availableForRight, "");
						const truncatedRightWidth = visibleWidth(truncatedRight);
						const padding = " ".repeat(Math.max(0, width - statsLeftWidth - truncatedRightWidth));
						statsLine = statsLeft + padding + truncatedRight;
					} else {
						statsLine = statsLeft;
					}

					// Dim each part separately (statsLeft may contain colored context %).
					const dimStatsLeft = theme.fg("dim", statsLeft);
					const remainder = statsLine.slice(statsLeft.length);
					const dimRemainder = theme.fg("dim", remainder);
					const pwdLine = truncateToWidth(theme.fg("dim", pwd), width, theme.fg("dim", "..."));

					return [pwdLine, dimStatsLeft + dimRemainder];
				},
			};
		});
	});
}
