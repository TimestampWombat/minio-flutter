@Root(name = "ScanRange")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class ScanRange {
  @Element(name = "Start", required = false)
  private Long start;

  @Element(name = "End", required = false)
  private Long end;

  /** Constructs ScanRange object for given start and end. */
  public ScanRange(Long start, Long end) {
    this.start = start;
    this.end = end;
  }
}
