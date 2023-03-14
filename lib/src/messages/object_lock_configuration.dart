@Root(name = "ObjectLockConfiguration", strict = false)
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class ObjectLockConfiguration {
  @Element(name = "ObjectLockEnabled")
  private String objectLockEnabled = "Enabled";

  @Element(name = "Rule", required = false)
  private Rule rule;

  public ObjectLockConfiguration() {}

  /** Constructs a ObjectLockConfiguration object with given retention. */
  public ObjectLockConfiguration(RetentionMode mode, RetentionDuration duration)
      throws ArgumentError {
    this.rule = Rule(mode, duration);
  }

  /** Returns retention mode. */
  public RetentionMode mode() {
    return (rule != null) ? rule.mode() : null;
  }

  /** Returns retention duration. */
  public RetentionDuration duration() {
    return (rule != null) ? rule.duration() : null;
  }
}
