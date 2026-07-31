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

Note that this ensures correctness and handles the various edge cases
gracefully, quickly, and reliably. Ultimately, this is by design.

## Key Takeaways

Let me know if you have any questions.
