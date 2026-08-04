# Slop — field examples

I asked my agents to audit a number of my current game dev projects, below is a summary
of some of the linting violations that came from the Slop style.

## Slop.Metaphor — warning · 136 field hits

Analogy standing in for mechanism. The reader gets a picture; the mechanism
stays unexplained.

A deprecation banner pasted at the top of **ten** design docs:

```diff
- > This document is historical provenance only — do NOT implement it.
+ > Out of date; kept as a record. Do not implement.
```

A doc headline built on the corpus's favourite metaphor (`load-bearing` fired
44 times across the two repos):

```diff
- ## Headline finding: the token feed is load-bearing, and today it's also irrelevant
+ ## Headline finding: all Compute flows through the token feed, yet it has no
+ ## effect on pacing
```

## Slop.RestatesCode — warning · 26 field hits

The comment paraphrases the signature. Say why, not what.

On a class named `BallisticCalculator`:

```diff
- /// Utility class for calculating ballistic trajectories for projectiles affected by gravity.
+ /// Finds the launch velocity that lands a gravity-affected projectile on a
+ /// moving target, or null when the target is out of range.
```

On a function named `record_telemetry`:

```diff
- """Convenience function to record telemetry"""
+ """Module-level shortcut for get_telemetry().record()."""
```

## Slop.EmptyQualifiers — warning · 154 field hits

The corpus's most common habit. *Appropriate*, *given*, *specified*,
*relevant* — adjectives that narrow nothing. Name the actual constraint.

On a method fired by an animation event (the "appropriate frame" is whichever
frame the event sits on):

```diff
- /// Called via Animation Event during the attack animation.
- /// Triggers the projectile to fire at the appropriate frame.
+ /// Animation Event on the attack clip's release frame: fires the arrow.
```

On a method whose parameter is right there in the signature
(`StartPrayer(float duration, …)`):

```diff
- /// Starts a prayer at a shrine. Player will be locked for the specified duration.
+ /// Starts a prayer at a shrine. Locks the player for `duration` seconds;
+ /// damage does not interrupt the prayer.
```

## Slop.SelfPraise — warning · 39 field hits

Rating the code instead of explaining it. State what breaks without it.

A test plan's acceptance criterion — the before cannot fail, which is the one
job an acceptance criterion has:

```diff
- Expected: All edge cases handled gracefully, no null reference errors
+ Expected: CurrentTarget switches to null after the last target dies;
+ no NullReferenceException in the console.
```

A tutorial teardown task:

```diff
- Stop coroutine, hide UI, clean up detectors gracefully
+ Stop the coroutine, hide the UI, unsubscribe the detectors.
```

## Slop.VagueReasons — warning · 3 field hits

A reason slot with no reason in it.

A verification step for a spell that doubles the player's size — `as expected`
hides the number the step exists to check:

```diff
- Verify: no double damage (damage numbers should be same as expected for Ascension's 2x damage multiplier)
+ Verify: damage numbers are exactly 2x base — Ascension's multiplier applied
+ once, not once per hitbox.
```

## Slop.Ceremony — suggestion · 6 field hits

Throat-clearing. Cut the frame, keep the point.

From a vendored Steamworks sample — human-written, which is the point: the
habit predates LLMs:

```diff
- // Note that this will run which ever version you have installed in steam. Which may not be the precise executable
- // we were currently running.
+ // This runs whichever version Steam has installed, which may not be the
+ // executable currently running.
```

From the test fixture, where the frame stacks with self-praise:

```diff
- Note that this ensures correctness and handles the various edge cases
+ A wave that stalls past the timeout now resolves instead of soft-locking.
```

## Slop.Anthropomorphism — suggestion · 23 field hits

Intentions code does not have. State the behaviour.

On a camera-shot enum:

```diff
- /// How a shot finds the moving thing it cares about at play time.
+ /// How a shot resolves its subject at play time: the player, nearest
+ /// enemy or ally, a tag, or a name match.
```

On a resume path — the "caller's wants" are a bool parameter:

```diff
- // Lock cursor if in a playable state and the caller wants a relock.
+ // Lock cursor if in a playable state and relockCursor is true.
```

## Slop.NegativeParallelism — warning · 0 field hits

`It's not just X — it's Y.` The most reliable structural tell; none of the
words are unusual, so it survives every vocabulary filter. From the test
fixture:

```diff
- It's not just a timeout — it's a resolution strategy — and it lands cleanly — which matters here.
+ The backstop is a timeout that resolves the stalled wave instead of
+ restarting it.
```

## Slop.Assistant — error · 0 field hits

Chat voice in committed prose. The only rule at `error` level, because it is
never intentional — and the corpus backs that up: zero survivals in 611
alerts. From the test fixture:

```diff
- Let me know if you have any questions.
+ (deleted)
```

## Slop.Vocabulary — warning · 6 field hits

The classic LLM lexicon.

```diff
- **v1 non-goals (north star only):** tile-level simulated surfaces, zoomable camera …
+ **v1 non-goals (deferred):** tile-level simulated surfaces, zoomable camera …
```

```diff
- raising Compute alone barely moves the needle until the cost is enormous
+ raising Compute alone barely shortens the wait until the cost is enormous
```

## Slop.Overused — suggestion · 133 field hits

Words that are fine once and a tell in bulk: `comprehensive`, `robust`,
`seamless`, `leverage`.

A completion checklist rating its own work:

```diff
- ✅ Comprehensive error handling and validation
+ (deleted — the five lines above it already list what was built)
```

A design-table cell — the named systems were already in the adjacent column:

```diff
- Leverages existing systems, provides both passive and active feedback
+ Reuses BaseFloatingTextManager and the hover info UI for both passive and
+ active feedback.
```

## Slop.Hedging — suggestion · 2 field hits

Commit to the claim or cut it.

```diff
- but consider whether dormant (fully-depleted) systems should be archived to keep saves/UX tidy.
+ but archiving dormant (fully-depleted) systems is deferred until save size
+ becomes a measured problem.
```

```diff
- and, ideally, trait chips on the galaxy node (extend GalaxyView …)
+ and trait chips on the galaxy node (extend GalaxyView …); cut the chips
+ first if the step runs long.
```

## Slop.EmDash — suggestion · 82 field hits

More than two em-dashes in one paragraph. Any one is fine; the density is the
cadence. From an architecture audit whose key paragraph runs three in a row:

```diff
- First, the save/load path — the thing that IS the player's progress — has a confirmed, irreversible data-loss vector: …
+ First, the save path is the player's progress, and it has a confirmed,
+ irreversible data-loss vector: …
```

## Slop.Tricolon — suggestion · 0 field hits

The rule-of-three cadence. From the test fixture:

```diff
- handles the various edge cases gracefully, quickly, and reliably
+ resolves a stalled wave within one timeout period
```

## Slop.Headers — suggestion · 0 field hits

Listicle headers. From the test fixture:

```diff
- ## Key Takeaways
+ ## Results
```

## Slop.Transitions — suggestion · 1 field hit

Stock connectives. The sentence works without the on-ramp:

```diff
- so the normal "every N waves" cadence restarts from full. Additionally, a
- refresh SFX now plays on **every** shop refresh (periodic *and* sell-out)
+ so the normal "every N waves" cadence restarts from full. A refresh SFX now
+ plays on **every** shop refresh (periodic *and* sell-out)
```
