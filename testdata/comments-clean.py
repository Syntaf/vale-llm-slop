"""Wave spawn scheduling.

Timing comes from waves.json so designers retune wave 12 without a rebuild.
"""

SPAWN_BUDGET = 24


def schedule(wave, budget=SPAWN_BUDGET):
    # Milestone waves (5, 10, 15) run long, so the budget doubles there.
    # Without this, the last three enemies spawn after the victory check and
    # the wave never ends.
    if wave % 5 == 0:
        budget *= 2
    return budget


def drain(queue):
    # Pop from the tail: the head holds the boss, which must spawn last.
    while queue:
        yield queue.pop()
