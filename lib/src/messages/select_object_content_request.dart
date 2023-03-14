@Root(name = "SelectObjectContentRequest")
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class SelectObjectContentRequest extends SelectObjectContentRequestBase {
  @Element(name = "RequestProgress", required = false)
  private RequestProgress requestProgress;

  @Element(name = "ScanRange", required = false)
  private ScanRange scanRange;

  /** Constructs SelectObjectContentRequest object for given parameters. */
  public SelectObjectContentRequest(
      @Nonnull String expression,
      boolean requestProgress,
      @Nonnull InputSerialization is,
      @Nonnull OutputSerialization os,
      @Nullable Long scanStartRange,
      @Nullable Long scanEndRange) {
    super(expression, is, os);
    if (requestProgress) {
      this.requestProgress = RequestProgress();
    }
    if (scanStartRange != null || scanEndRange != null) {
      this.scanRange = ScanRange(scanStartRange, scanEndRange);
    }
  }
}
