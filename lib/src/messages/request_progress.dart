@Root(name = "RequestProgress", strict = false)
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class RequestProgress {
  @Element(name = "Enabled")
  private boolean enabled = true;

  /** Constructs a RequestProgress object. */
  public RequestProgress() {}
}
