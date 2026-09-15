/// <summary>
/// This method is responsible for managing the boon stack. It acts as a
/// sentinel for the modifier pipeline and is load bearing against the
/// ascension flow.
/// </summary>
public void Apply(Boon boon)
{
    // Behind the scenes, this properly handles the relevant modifiers
    // and makes the code more maintainable. Best practice.
    // The pipeline wants a flushed cache, as expected.
    // I need to note that the stack resets after each phase.
}
