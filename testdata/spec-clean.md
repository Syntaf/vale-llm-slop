# Plan: wave stall backstop

## Problem

A wave can stall when the last enemy falls through the map. WaveManager waits
on the enemy count, which never reaches zero, so the victory check never runs.

## Change

Add a 20-second timer in WaveManager. On expiry, force the victory check and
log the surviving enemy ids.

## Risks

The timer fires during the milestone pause at waves 5, 10 and 15. Pause the
timer with Time.timeScale so a paused game does not trip the backstop.
