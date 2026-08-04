# STE — field examples

I asked my agents to audit a number of my current game dev projects, below is a summary
of some of the linting violations that came from the Slop style.

---

## STE.SentenceLength — descriptive sentences ≤ 25 words

The corpus record is a **112-word sentence** (from the other repo's
powder-keg design doc) that chains nine manual verification steps through
semicolons:

```diff
- pick up a keg, confirm it floats in front and tracks the player; walk into a
- wall and an ally and confirm each detonates while held; throw and confirm the
- lobbed arc; confirm a thrown keg passes over the ground without exploding and
- detonates on an enemy; confirm a landed keg can be re-picked-up; …
+ 1. Pick up a keg. Confirm it floats in front of the player.
+ 2. Walk into a wall, then an ally. Confirm each detonates the held keg.
+ 3. Throw the keg. Confirm the lobbed arc.
+ 4. Throw across open ground. Confirm it explodes on an enemy, not the ground.
+ 5. Pick up a landed keg. Confirm pickup works a second time.
```

The audit's summary paragraph runs a 62-word sentence:

```diff
- First, the save/load path — the thing that IS the player's progress — has a
- confirmed, irreversible data-loss vector: a corrupt active-save read silently
- returns null with no backup, boots a fresh game on the same id, and lets the
- next 30s autosave overwrite the unreadable file, …
+ The save path is the player's progress, and it has a confirmed, irreversible
+ data-loss vector. A corrupt save read returns null with no backup. The game
+ then boots fresh on the same id. The next 30-second autosave overwrites the
+ unreadable file.
```

## STE.ProcedureLength — list items ≤ 20 words

A 54-word list item:

```diff
- 2. The data-driven research-effect framework is elegant and extensible: a
-    ModStat-keyed prebuilt index so each lookup walks only its stat's
-    modifiers, ModEvalCtx passed by 'in' (no per-call alloc), and
-    ResearchEffects.Matches reused verbatim by SystemModifiers …
+ 2. The research-effect framework is data-driven.
+    - A prebuilt index keyed by ModStat limits each lookup to one stat.
+    - ModEvalCtx passes by 'in', so a call does not allocate.
+    - SystemModifiers reuses ResearchEffects.Matches, so traits and research
+      gate the same way.
```

## STE.ParagraphLength — paragraphs ≤ 6 sentences

The audit's theme paragraph runs 7 sentences. The fix is structural, not
verbal: the paragraph already contains two topics (why findings rated medium,
then where they concentrate) — split it at the topic change.

## STE.Articles — do not drop *the*/*a*

Telegram style reads faster to the writer and slower to everyone else:

```diff
- 4. Clean hot-path performance seams worth preserving: …
+ 4. The hot paths have clean performance seams. Keep them: …
```

```diff
- Remove dead serialized fields
+ Remove the dead serialized fields
```

## STE.Gerunds — rewrite -ing forms with finite verbs

```diff
- ## Strong areas — worth protecting as you grow
+ ## Strong areas — protect these as the project grows
```

```diff
- the user's stated concern (a game that keeps growing)
+ the user's stated concern (a game that must continue to grow)
```

## STE.PassiveVoice — name the agent

```diff
- 1. Architecture contract is genuinely enforced, not aspirational: …
+ 1. The asmdef enforces the architecture contract: …
```

```diff
- the shipped research graph is never validated at runtime
+ no code validates the shipped research graph at runtime
```

## STE.NounClusters — no more than three nouns in a row

The audit's own title is the first hit in the file:

```diff
- # Claude Planet Idler — Architecture & Code-Quality Audit
+ # An audit of the architecture and code quality of Claude Planet Idler
```

```diff
- a graph-wiring regression passes CI unnoticed
+ a regression in the wiring of the graph passes CI unnoticed
```

## STE.Ambiguity — write the alternatives out in full

Slashed pairs make the reader do the disambiguation:

```diff
- every high/critical finding adversarially re-verified against the cited code
+ every finding rated high or critical re-verified against the cited code
```

```diff
- First, the save/load path … has a confirmed, irreversible data-loss vector
+ First, the save and load path … has a confirmed, irreversible data-loss vector
```

## STE.Modals — *should* → *must*, *may* → *can*

STE treats *should* as a requirement the writer declined to make:

```diff
- the model the map and charting layers should follow
+ the model the map and charting layers must follow
```

From a reorg plan in the other repo, where *may* hides an unmade decision:

```diff
- keep for now as it's under NPC/ and may be planned.
+ keep for now: it is under NPC/ and a Zombie variant is still possible.
```

## STE.Contractions — expand them

```diff
- don't let purchasable dead ends ship
+ do not let purchasable dead ends ship
```

```diff
- a typo'd id ships a silently soft-locked node
+ a mistyped id ships a silently soft-locked node
```

## STE.OneInstruction — one instruction per sentence

`, then` is the tell — two steps filed as one:

```diff
- Corrupt active-save read silently returns null with NO backup, then next
- autosave permanently overwrites it
+ A corrupt active-save read returns null with no backup. The next autosave
+ then permanently overwrites the file.
```

From the other repo's item-system doc:

```diff
- 2. ItemPedestal.Interact spends gold via PlayerHealth.SpendGold (skipped when
-    effective cost is 0), then calls ItemShop.HandlePurchase.
+ 2. ItemPedestal.Interact spends gold via PlayerHealth.SpendGold. When the
+    effective cost is 0, it skips the spend. It then calls
+    ItemShop.HandlePurchase.
```

## STE.Dictionary — prefer the plain word

The shipped substitutions are ordinary plain-English swaps (the copyrighted
ASD word list is not included — see [ste-dictionary.md](ste-dictionary.md)):

```diff
- Treat the percentage portion of Effect as data
+ Treat the percentage part of Effect as data
```

```diff
- SizeMarker==SizeRing byte-identical
+ SizeMarker and SizeRing are byte-for-byte the same
```
