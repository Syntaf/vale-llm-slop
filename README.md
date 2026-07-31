# vale-llm-slop

Two [Vale](https://vale.sh) styles for prose that machines write.

**`Slop`** targets the register LLM agents produce in docstrings, code comments,
specs and plans: metaphor where mechanism belongs, qualifiers that qualify
nothing, comments that restate the line below them.

**`STE`** implements the writing rules of
[ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/) for
teams that want the stricter, controlled-language version.

Both run over source files directly. Vale reads comments and docstrings and
skips string literals, so you can lint `.py`, `.cs`, `.ts`, `.go` and friends
without touching the code itself.

## The problem it solves

```
# Reads as the provenance for the firm grain-matched against the fund.
# Load bearing against the user's request for firm context.
```

Every word is English. None of them say what the code does. This is what an
agent produces when it is summarising rather than explaining, and it survives
every spell-checker and every vocabulary blocklist, because none of the words
are unusual.

`vale-llm-slop` reports four separate findings on those two lines.

## Install

Add to your `.vale.ini`:

```ini
StylesPath = .vale
MinAlertLevel = warning
Packages = https://github.com/Syntaf/vale-llm-slop/releases/latest/download/vale-llm-slop.zip

# Docstrings and comments in source files.
[*.{py,cs,ts,tsx,js,go,rs,rb,java,kt,swift,php,c,cpp,h}]
BasedOnStyles = Slop

# Agent-authored specs, plans and docs.
[*.md]
BasedOnStyles = Slop
```

Then `vale sync`.

Or vendor it — copy `styles/Slop` into your own `StylesPath` and skip the
package machinery entirely.

## Setup: Python projects with uv

Vale is a Go binary, but there is a PyPI wrapper that fetches it, so it can be
a normal dev dependency.

```sh
uv add --dev vale
uv run vale --version      # downloads the binary on first run
```

Prefer a machine-wide tool instead of a project dependency:

```sh
uv tool install vale
```

Write `.vale.ini` at the repo root:

```ini
StylesPath = .vale
MinAlertLevel = warning
Packages = https://github.com/Syntaf/vale-llm-slop/releases/latest/download/vale-llm-slop.zip

[*.py]
BasedOnStyles = Slop

# Agent-authored specs, plans and design docs.
[*.md]
BasedOnStyles = Slop

# Generated code has no prose worth linting.
[**/migrations/*.py]
BasedOnStyles = ""
[**/*_pb2.py]
BasedOnStyles = ""
```

Fetch the styles, then run it:

```sh
uv run vale sync           # re-run whenever the package version changes
uv run vale src/
```

Add `.vale/` to `.gitignore` — `vale sync` repopulates it.

### Version note

`uv add --dev vale` currently installs Vale **3.13.0**. All 16 `Slop` rules
work on it, with no behavioural difference from the latest release. Two `STE`
rules — `Gerunds` and `NounClusters` — rely on part-of-speech tagging that
needs **3.16.0 or newer**; on 3.13.0 they silently never fire. If you want
those, install the binary directly (`brew install vale`) instead of via PyPI.

Nothing else in either style is version-sensitive.

### Exit codes, and gating CI

Vale exits non-zero **only** for `error`-level alerts. `MinAlertLevel` and
`--minAlertLevel` change what is printed, not the exit code, so a build with
forty warnings still passes. To make a rule block a build, promote it:

```ini
[*.py]
BasedOnStyles = Slop
Slop.Metaphor = error
Slop.RestatesCode = error
```

A reasonable pilot sequence: start with everything reporting and nothing
gating, read a week of output, then promote the two or three rules that were
right every time.

### GitHub Actions

```yaml
- uses: astral-sh/setup-uv@v5
- run: uv sync --dev
- run: uv run vale sync
- run: uv run vale src/
```

### pre-commit

The upstream hook builds Vale from source with the Go toolchain. In a uv repo
it is simpler to reuse the pinned dev dependency:

```yaml
repos:
  - repo: local
    hooks:
      - id: vale
        name: vale
        entry: uv run vale
        language: system
        types: [python]
```

Run `uv run vale sync` once before the first commit, or the hook fails with
`style 'Slop' does not exist on StylesPath`.

### What to expect on a real Python codebase

The style was checked against Google, NumPy and Sphinx docstring conventions.
`Args:`, `Returns:`, `Raises:`, the NumPy `Parameters/-----` block, Sphinx
`:param:` and `:returns:` fields, `# noqa`, `# type: ignore` and `TODO(name):`
comments all pass clean.

One idiom does fire, and it is the first thing to tune:

```python
def render(template, context):
    """Render a template with the given context."""   # Slop.EmptyQualifiers
```

*the given X* is everywhere in Python docstrings. The rule is right on the
merits — the adjective narrows nothing — but if it is too noisy on day one:

```ini
[*.py]
Slop.EmptyQualifiers = suggestion
```

Vale reads docstrings and comments and skips string literals, so no rule can
fire on your data or your test fixtures.

## The rules

### Slop — agent prose

| Rule | Catches | Level |
|---|---|---|
| `Metaphor` | Analogy standing in for mechanism: *reads as the*, *acts as a*, *load bearing against*, *provenance*, *grain-matched*, *is essentially a* | warning |
| `RestatesCode` | Comments that paraphrase the signature: *This function returns*, *Loop through each*, *Initialize the result variable* | warning |
| `EmptyQualifiers` | Adjectives that narrow nothing: *the appropriate handler for the given request* | warning |
| `SelfPraise` | Rating the code instead of explaining it: *ensures correctness*, *handles this gracefully*, *best practice* | warning |
| `VagueReasons` | A reason slot with no reason in it: *for various reasons*, *due to the nature of* | warning |
| `Ceremony` | Throat-clearing: *Note that*, *Under the hood*, *At a high level* | suggestion |
| `Anthropomorphism` | Intentions code does not have: *the parser wants*, *knows about* | suggestion |

### Slop — general machine cadence

| Rule | Catches | Level |
|---|---|---|
| `NegativeParallelism` | *It's not just X — it's Y*, *not only … but also* | warning |
| `Assistant` | Chat voice in committed prose: *Great question*, *I hope this helps* | error |
| `Vocabulary` | *delve*, *tapestry*, *paradigm shift*, *let's dive in* | warning |
| `Overused` | *robust*, *seamless*, *comprehensive*, *leverage* | suggestion |
| `Hedging` | *should probably*, *consider whether*, *we may want to* | suggestion |
| `EmDash` | More than two em-dashes in one paragraph | suggestion |
| `Tricolon` | *gracefully, quickly, and reliably* | suggestion |
| `Headers` | *Key Takeaways*, *A Deep Dive*, *Why X Matters* | suggestion |
| `Transitions` | *Moreover,*, *Ultimately,*, *At its core,* | suggestion |

### STE — ASD-STE100 writing rules

`SentenceLength` (25 words), `ProcedureLength` (20 words in list items),
`ParagraphLength` (6 sentences), `Articles`, `Gerunds`, `PassiveVoice`,
`NounClusters`, `Ambiguity` (*and/or*, *etc.*, *e.g.*), `Modals`
(*shall* → *must*), `Contractions`, `OneInstruction`, `Dictionary`.

`STE` is stricter than most teams want on ordinary prose. Scope it to the docs
that need it.

**The STE Dictionary is not included.** ASD holds copyright on the ~900-word
approved list, so `Dictionary.yml` ships ordinary plain-English substitutions
instead. See [docs/ste-dictionary.md](docs/ste-dictionary.md) for how to build
the full rule locally from your own copy of the specification.

## Tuning

Every style gets muted eventually if it cries wolf, so precision was the design
constraint. Two consequences:

**Terms of art are excluded by lookaround.** `SLSA provenance`, `build
provenance`, `sentinel value`, `sentinel node` and `load-bearing wall` do not
fire. `testdata/exclusions-clean.py` asserts this, and `scripts/test.sh` fails
if it breaks. Add your own domain's exclusions the same way.

**Levels are deliberate.** `Assistant` is an `error` because chat voice in a
commit is never intentional. `Ceremony` and `Overused` are `suggestion` because
any single hit may be correct — the signal there is density.

Turn anything off per-path:

```ini
[legacy/**/*.py]
Slop.RestatesCode = NO
```

Exclude the styles themselves if you lint your whole repo — the rule files
quote the phrases they ban:

```ini
[styles/**]
BasedOnStyles = ""
```

## Tests

```sh
./scripts/test.sh          # uses `vale` from PATH
VALE=/path/to/vale ./scripts/test.sh
```

Two properties are asserted: every rule fires at least once on a dirty fixture
(no dead rules), and the clean fixtures produce **zero** alerts (no false
positives). Currently 28 rules, 80 alerts on the dirty fixtures, 0 on the clean
ones.

## A note on the author

This repo was written by an LLM agent, and the `Slop` style flags its own
first draft. "The signal is density, not any single hit." "Less elegant and
much more reliable." "A style people mute is worse than none." Three instances
of the negative-parallelism cadence, written into the comments of the rule file
that bans it.

That is the argument for the linter, not against it. The habit is not
detectable from the inside.

## Licence

MIT. See [LICENSE](LICENSE). Not affiliated with or endorsed by ASD.
