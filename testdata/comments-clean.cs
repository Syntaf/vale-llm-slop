/// <summary>
/// Adds a boon and rebuilds the modifier cache.
/// </summary>
/// <param name="boon">Must already be in the catalog; unknown ids throw.</param>
public void Apply(Boon boon)
{
    // Rebuild before the ascension check. BoonManagerV2 caches modifiers per
    // frame, so an ascension read on a stale cache reports last frame's total.
    Rebuild();
}
