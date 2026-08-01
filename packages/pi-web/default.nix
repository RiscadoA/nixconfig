# packages/pi-web/default.nix
#
# pi-web: web UI for persistent Pi Coding Agent sessions in real workspaces.
# https://pi-web.dev/ | https://github.com/jmfederico/pi-web
#
# Runtime requirements (from the upstream docs):
# - Node.js >= 22.19.0 (we pin nodejs_22)
# - Pi Coding Agent >=0.82.1 <0.83 — satisfied at the *library* level: pi-web
#   embeds @earendil-works/pi-coding-agent (peer dependency, resolved by npm
#   to 0.82.x) and runs agent sessions in-process. The system `pi` CLI is only
#   used for `pi install/remove/update` package management, so the pi binary
#   version does not gate sessions.

{ lib, buildNpmPackage, fetchFromGitHub, nodejs_22, python3, gnumake, stdenv }:
buildNpmPackage rec {
  pname = "pi-web";
  version = "1.202607.3";

  src = fetchFromGitHub {
    owner = "jmfederico";
    repo = "pi-web";
    rev = "v${version}";
    hash = "sha256-sy3V0Z0Ft2ECyAX1y29OKxD7bi1guNn5OF9eOW2kY3E=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-v9QC4SxEH12JgF76olNtWmnuqQXz2TkU3znwpd47zco=";

  # fetcher v1 only caches tarballs; npm ci also needs packuments for the
  # nested @earendil-works peer installs. v2 caches packuments (and needs a
  # writable cache, since multiple entries share cache keys).
  npmDepsFetcherVersion = 2;
  makeCacheWritable = true;

  # The published package-lock.json omits `integrity` for three nested dev
  # entries (@earendil-works/pi-{agent-core,ai,tui} inside pi-coding-agent's
  # node_modules). prefetch-npm-deps refuses non-git deps without integrity, so
  # inject the correct registry SRI hashes. fetchNpmDeps inherits postPatch,
  # so the fixed lockfile is also what npm ci validates against.
  #
  # The @earendil-works/pi-* packages are both devDependencies and
  # peerDependencies of pi-web; `npm prune --omit=dev` therefore strips them,
  # yet they are required at runtime (session daemon imports pi-coding-agent
  # in-process). Drop them from devDependencies so npm treats them as pure
  # peers and keeps them after pruning.
  postPatch = ''
    ${nodejs_22}/bin/node -e '
      const fs = require("node:fs");
      const lock = JSON.parse(fs.readFileSync("package-lock.json", "utf8"));
      const hashes = {
        "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-agent-core": "sha512-Z3kloziJIE2dmrisRckZX8zDca/gIv9/YdFAzeoqpHiLV2wsni6bL4hInNSjVKLbqT+4kqLIkph2JQLKvSepjg==",
        "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-ai": "sha512-3WFYRhEp3lQB3444EhPMBcM7zSaEUE3eJgHOR7s4081NLqbw/FsWilIKWXSua0Gv3sRr7m9xMidR3pPDE7jI/A==",
        "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-tui": "sha512-9yN8hALfKaxZq7n54EMxqhFCWnMi6LHkraMJ/1YjHiATq75XrI6XDMVppn9EDtiK7Fks8hUe1SDXUTrIvwRWfQ=="
      };
      for (const [key, value] of Object.entries(hashes)) {
        if (!lock.packages[key]) throw new Error("lockfile entry missing: " + key);
        lock.packages[key].integrity = value;
      }
      // npm marks @earendil-works/* as dev:true (they are both dev and peer
      // deps), so `npm prune --omit=dev` would strip them at install time.
      // They are required at runtime, so demote the whole subtree out of dev.
      for (const key of Object.keys(lock.packages)) {
        if (key.includes("@earendil-works")) delete lock.packages[key].dev;
      }
      fs.writeFileSync("package-lock.json", JSON.stringify(lock, null, 2) + "\n");

      const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));
      if (!pkg.devDependencies) throw new Error("package.json has no devDependencies");
      for (const name of ["@earendil-works/pi-ai", "@earendil-works/pi-agent-core", "@earendil-works/pi-coding-agent"]) {
        delete pkg.devDependencies[name];
      }
      fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2) + "\n");
    '
  '';


  # node-pty (^1.1.0) compiles its native module from source and must run its
  # install script during `npm rebuild`. Unlike pi-coding-agent, we must NOT
  # pass --ignore-scripts here.
  nativeBuildInputs = [ python3 gnumake stdenv.cc ];

  # Default build script: clean + tsc + plugin-api + plugins + vite build.
  # npmRebuildFlags defaults to [] so install scripts (node-pty) run.

  meta = {
    description = "Web UI for persistent Pi Coding Agent sessions in real workspaces";
    homepage = "https://pi-web.dev/";
    license = lib.licenses.mit;
    mainProgram = "pi-web";
    platforms = lib.platforms.linux;
  };
}
