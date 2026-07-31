# The STE dictionary, and why it is not in this repo

ASD-STE100 has two halves. This repo implements one of them well and one of
them partially, and the reason is licensing, not effort.

## What ships here

`styles/STE/` implements the **writing rules** — sentence length, paragraph
length, articles, gerunds, passive voice, noun clusters, ambiguous
constructions, modal verbs, contractions, one-instruction-per-sentence.
These are functional constraints. Expressing them as regexes and POS sequences
is original work.

`styles/STE/Dictionary.yml` is a **plain-English substitution list** drawn from
the ordinary public plain-language canon (GOV.UK, plainlanguage.gov, 18F):
prefer the short common word. It overlaps with STE in spirit and catches a
useful share of real violations.

## What does not ship here

The **ASD-STE100 Dictionary** itself: roughly 900 approved words, each with its
approved part of speech and approved meaning, plus the list of non-approved
words with their approved alternatives.

That dictionary is copyrighted by ASD (AeroSpace, Security and Defence
Industries Association of Europe). The specification is available at no cost
from <https://www.asd-ste100.org/>, but "free to download" is not "free to
redistribute". Publishing the full mapping in a public repository would be a
derivative of their copyrighted work.

**This is a practical caution, not legal advice.** If your organisation has a
licence, or you read ASD's terms differently, generate the full rule locally
using the recipe below.

## Building the full dictionary rule locally

1. Download the current issue of the specification from asd-ste100.org.
2. Extract the non-approved word column and its approved alternative.
3. Emit a `substitution` rule with the same shape as `Dictionary.yml`:

```yaml
extends: substitution
message: "STE: use '%s' instead of '%s'."
level: error
ignorecase: true
swap:
  <non-approved>: <approved alternative>
```

4. Save it as `styles/STE/DictionaryFull.yml` in **your own** StylesPath, and
   add `styles/STE/DictionaryFull.yml` to `.gitignore` if the repo is public.

Two things to get right when you generate it:

- **Use `\s+` for spaces in multi-word entries.** Markdown is hard-wrapped, and
  a literal space silently fails to match any phrase that straddles a line
  break. This bit every multi-word rule in this repo before it was fixed.
- **Do not blanket-swap words that STE itself approves.** "Remove" is an
  approved STE verb; a naive plain-language list will try to rewrite it to
  "take off" and undo the standard you are trying to enforce.

## The part no dictionary rule can do

STE restricts each approved word to one part of speech *and one meaning*.
"Oil" is an approved noun, so "Oil the bearing" is a violation. "Follow" is
approved as *come after*, not *obey*.

The part-of-speech half is partly reachable — see `Gerunds.yml` and
`NounClusters.yml` for `sequence` rules that use Vale's tagger. The **meaning**
half is not reachable by any lint rule. That is the honest ceiling of this
repo: it will find violations, it will not certify compliance.
