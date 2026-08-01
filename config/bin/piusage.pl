#!/usr/bin/env perl
# piusage - aggregate pi token usage across all sessions.
# Reads session JSONL files under ~/.pi/agent/sessions/**/*.jsonl
use strict;
use warnings;
use File::Find;
use Time::Local qw(timegm timelocal);

my $dir = $ENV{PI_SESSION_DIR} // "$ENV{HOME}/.pi/agent/sessions";
my $days = shift // 14;

my @files;
find(sub { push @files, $File::Find::name if /\.jsonl$/ }, $dir) if -d $dir;

my %by_day;      # YYYY-MM-DD -> {tokens, cost}
my %by_week;     # YYYY-WW    -> {tokens, cost}
my %by_month;    # YYYY-MM    -> {tokens, cost}
my %by_project;  # dir        -> {tokens, cost}
my ($tot_tokens, $tot_cost) = (0, 0);
my $msgs = 0;

# local now
my $now = time();
my ($y, $m, $d, $wday) = (localtime($now))[5,4,3,6];
my $today = sprintf("%04d-%02d-%02d", $y+1900, $m+1, $d);

sub usage_obj {
  my ($line) = @_;
  # extract the flat JSON object after "usage":  (nested cost object is flat)
  return undef unless $line =~ /"usage":(\{.*?\})/;
  my $u = $1;
  my $tokens = $u =~ /"totalTokens":(\d+)/ ? $1 : undef;
  my $cost   = $u =~ /"cost":\{"[^}]*"total":([\d.eE+-]+)/ ? $1 : 0;
  return ($tokens, $cost);
}

for my $f (@files) {
  open(my $fh, "<", $f) or next;
  while (my $line = <$fh>) {
    next unless $line =~ /"type":"message"/ && $line =~ /"usage"/;
    next unless $line =~ /"timestamp":"([^"]+)"/;
    my $ts = $1;                      # ISO8601 UTC, e.g. 2026-08-01T16:10:29.565Z
    $ts =~ /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})/ or next;
    my $epoch = timegm(0, $5, $4, $3, $2-1, $1-1900);  # UTC
    my ($tokens, $cost) = usage_obj($line);
    next unless defined $tokens;
    $msgs++;
    $tot_tokens += $tokens;
    $tot_cost += $cost;
    # local calendar buckets
    my @lt = localtime($epoch);
    my $ld = sprintf("%04d-%02d-%02d", $lt[5]+1900, $lt[4]+1, $lt[3]);
    my $wk = sprintf("%04d-W%02d", $lt[5]+1900, int(($lt[7]+6)/7));
    my $mo = sprintf("%04d-%02d", $lt[5]+1900, $lt[4]+1);
    $by_day{$ld}{tokens} += $tokens;  $by_day{$ld}{cost} += $cost;
    $by_week{$wk}{tokens} += $tokens; $by_week{$wk}{cost} += $cost;
    $by_month{$mo}{tokens} += $tokens; $by_month{$mo}{cost} += $cost;
    # project from file path
    if ($f =~ m{/--([^/]+)--/}) {
      my $p = $1;
      $by_project{$p}{tokens} += $tokens; $by_project{$p}{cost} += $cost;
    }
  }
  close($fh);
}

sub fmt {
  my ($tokens, $cost) = @_;
  return sprintf("%12d tok  %9s", $tokens, "\$$cost");
}

my $t = $tot_tokens; my $c = $tot_cost;
print "pi usage (from " . scalar(@files) . " session files, $msgs assistant messages)\n";
print "-" x 60, "\n";
print "  today        " . fmt($by_day{$today}{tokens} // 0, $by_day{$today}{cost} // 0) . "\n";
# this week: sum days with same Monday
my $monday = $now - $wday * 86400;
my $week_tok = my $week_cost = 0;
for my $k (keys %by_day) {
  my @lt = split /-/, $k;
  my $ep = timelocal(0,0,0, $lt[2], $lt[1]-1, $lt[0]-1900);
  next unless $ep >= $monday;
  $week_tok += $by_day{$k}{tokens}; $week_cost += $by_day{$k}{cost};
}
print "  this week    " . fmt($week_tok, $week_cost) . "  (since Mon)\n";
my $mo = sprintf("%04d-%02d", (localtime($now))[5]+1900, (localtime($now))[4]+1);
print "  this month   " . fmt($by_month{$mo}{tokens} // 0, $by_month{$mo}{cost} // 0) . "\n";
my $last30_tok = my $last30_cost = 0;
for my $k (keys %by_day) {
  my @lt = split /-/, $k;
  my $ep = timelocal(0,0,0, $lt[2], $lt[1]-1, $lt[0]-1900);
  next unless $ep >= $now - 30*86400;
  $last30_tok += $by_day{$k}{tokens}; $last30_cost += $by_day{$k}{cost};
}
print "  last 30 days " . fmt($last30_tok, $last30_cost) . "\n";
print "  all time     " . fmt($t, $c) . "\n";

print "-" x 60, "\n";
print "Daily breakdown (last $days days):\n";
my @days = sort keys %by_day;
for my $k (reverse @days) {
  my @lt = split /-/, $k;
  my $ep = timelocal(0,0,0, $lt[2], $lt[1]-1, $lt[0]-1900);
  next unless $ep >= $now - $days*86400;
  printf "  %s  %s\n", $k, fmt($by_day{$k}{tokens}, $by_day{$k}{cost});
}

print "-" x 60, "\n";
print "By project:\n";
for my $p (sort { $by_project{$b}{tokens} <=> $by_project{$a}{tokens} } keys %by_project) {
  printf "  %-45s %s\n", $p, fmt($by_project{$p}{tokens}, $by_project{$p}{cost});
}
