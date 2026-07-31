"""Legitimate uses of the flagged terms. This file must stay at zero alerts.

Every term below is real vocabulary in its home domain. A style that cannot
tell these from the metaphorical use is a style that gets muted in a week,
so these carve-outs are asserted by scripts/test.sh.
"""

# SLSA provenance is attached to every build artifact.
# build provenance and data provenance are both recorded in the manifest.
# The parser treats a missing sentinel value as end-of-stream.
# A sentinel node terminates the list; the sentinel entry is never freed.
# The rack bolts to the load-bearing wall studs rather than the drywall.
# Cache keys are fine-grained; coarse-grained keys collide across tenants.
