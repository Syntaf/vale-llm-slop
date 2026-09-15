#!/usr/bin/env bash
# Regression tests for the Slop and STE styles.
#
#   ./scripts/test.sh            # uses `vale` from PATH
#   VALE=/path/to/vale ./scripts/test.sh
#
# Two properties are asserted:
#   1. every rule fires at least once on a dirty fixture (no dead rules)
#   2. the clean fixtures produce ZERO alerts (no false positives)
# Property 2 is the one that matters. A style people mute is worse than none.
set -euo pipefail
cd "$(dirname "$0")/.."

VALE="${VALE:-vale}"
command -v "$VALE" >/dev/null 2>&1 || { echo "vale not found; set VALE=/path/to/vale"; exit 127; }

"$VALE" --no-exit --output=JSON \
  testdata/comments-dirty.py testdata/comments-clean.py \
  testdata/comments-dirty.cs testdata/comments-clean.cs \
  testdata/spec-dirty.md     testdata/spec-clean.md \
  testdata/ste-dirty.md      testdata/ste-clean.md \
  testdata/exclusions-clean.py > /tmp/vale-llm-slop-results.json

python3 - <<'PY'
import json, sys

with open('/tmp/vale-llm-slop-results.json') as fh:
    results = json.load(fh)

def alerts(name):
    for path, items in results.items():
        if path.endswith(name):
            return items
    return []

failures = []

# --- 1. no false positives on clean prose -------------------------------
for clean in ('comments-clean.py', 'comments-clean.cs', 'spec-clean.md',
              'ste-clean.md', 'exclusions-clean.py'):
    got = alerts(clean)
    if got:
        failures.append(f"{clean}: expected 0 alerts, got {len(got)}")
        for a in got:
            failures.append(f"    {a['Check']} L{a['Line']}: {a['Match']!r}")

# --- 2. every rule fires somewhere on the dirty fixtures -----------------
fired = {a['Check'] for f in ('comments-dirty.py', 'comments-dirty.cs',
                              'spec-dirty.md', 'ste-dirty.md') for a in alerts(f)}

expected = {
    # the agent-comment rules — the primary target
    'Slop.Metaphor', 'Slop.EmptyQualifiers', 'Slop.RestatesCode', 'Slop.Ceremony',
    'Slop.SelfPraise', 'Slop.Anthropomorphism', 'Slop.VagueReasons',
    # general machine-prose cadence
    'Slop.Vocabulary', 'Slop.Overused', 'Slop.NegativeParallelism', 'Slop.EmDash',
    'Slop.Tricolon', 'Slop.Headers', 'Slop.Assistant', 'Slop.Transitions',
    'Slop.Hedging',
    # self-referential tells
    'Slop.ProcessNarration', 'Slop.FillerConstruction', 'Slop.SelfHedging',
    'Slop.SelfReference',
    # ASD-STE100
    'STE.SentenceLength', 'STE.ProcedureLength', 'STE.ParagraphLength',
    'STE.Gerunds', 'STE.PassiveVoice', 'STE.NounClusters', 'STE.Articles',
    'STE.Ambiguity', 'STE.Modals', 'STE.Contractions', 'STE.OneInstruction',
    'STE.Dictionary',
}
for rule in sorted(expected - fired):
    failures.append(f"dead rule: {rule} never fired on any dirty fixture")

# --- 3. the specific terms-of-art exclusions hold ------------------------
# These are the whole reason the style is usable on technical prose.
for term in ('SLSA provenance', 'build provenance', 'sentinel value',
             'sentinel node', 'load-bearing wall', 'fine-grained'):
    for a in alerts('exclusions-clean.py'):
        if term.split()[0].lower() in a['Match'].lower():
            failures.append(f"exclusion broken: {term!r} flagged by {a['Check']}")

if failures:
    print('FAIL')
    for f in failures:
        print(' ', f)
    sys.exit(1)

total = sum(len(v) for v in results.values())
print(f'PASS  {len(fired)} rules fired, {total} alerts on dirty fixtures, 0 on clean')
PY
