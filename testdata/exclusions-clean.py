"""Legitimate uses of the flagged terms. This file must stay at zero alerts.

Every term below is real vocabulary in its home domain. A style that cannot
tell these from the metaphorical use is a style that gets muted in a week,
so these carve-outs are asserted by scripts/test.sh.
"""

# SLSA provenance is attached to every build artifact.
# build provenance and data provenance are both recorded in the manifest.
# The parser treats a missing sentinel value as end-of-stream.
# A sentinel node terminates the list; the sentinel entry is never freed.
# The stream ends with a `$stream_error` sentinel; consumers check for it.
# Writes the sentinel on a signal-driven exit, then re-raises.
# `False` is the "not yet resolved" sentinel for the cached lookup.
# We stash each UUID behind a sentinel before scrubbing, then restore it.
# Callers need not inspect a return-code sentinel; it aborts on failure.
# Wheel filenames normalize dashes to underscores per PEP 427.
# Reads PLUGIN_BASE_URL (uppercased, dashes to underscores).
# Hyphens are normalized to underscores so a key like doc-ai matches doc_ai.
# Each flag becomes a keyword parameter matching the underscore convention.
# The rack bolts to the load-bearing wall studs rather than the drywall.
# Cache keys are fine-grained; coarse-grained keys collide across tenants.
