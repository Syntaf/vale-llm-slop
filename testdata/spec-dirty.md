# Plan: Wave Stall Backstop

## Overview

This plan is essentially a comprehensive approach to the wave stall problem. At
a high level, the backstop acts as a sentinel for the wave lifecycle and is load
bearing against the straggler system. It's not just a timeout — it's a
resolution strategy — and it lands cleanly — which matters here.

Let's dive in with a deep dive into the wave system.

## Implementation

We should probably add a watchdog. Consider whether the timer belongs in the
manager. We may want to leverage the existing event channel where appropriate.
The retry storm underscores the need for a circuit breaker here. I need to note
that the timer must survive the milestone pause.

I can see the issue is that the pause logic doesn't account for the backstop.
I can tell you need a separate guard for the timer expiry.

Note that this ensures correctness and handles the various edge cases
gracefully, quickly, and reliably. Ultimately, this is by design.

I'll explain how the timer integrates with the pause logic below.

You can go ahead and wire the timer into the existing event loop.

## Key Takeaways

Let me know if you have any questions.
