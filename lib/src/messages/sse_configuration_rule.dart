@Root(name = "Rule")
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class SseConfigurationRule {
  @Path(value = "ApplyServerSideEncryptionByDefault")
  @Element(name = "KMSMasterKeyID", required = false)
  private String kmsMasterKeyId;

  @Path(value = "ApplyServerSideEncryptionByDefault")
  @Element(name = "SSEAlgorithm")
  private SseAlgorithm sseAlgorithm;

  /** Constructs server-side encryption configuration rule. */
  public SseConfigurationRule(
      @Nonnull @Element(name = "SSEAlgorithm") SseAlgorithm sseAlgorithm,
      @Nullable @Element(name = "KMSMasterKeyID", required = false) String kmsMasterKeyId) {
    this.sseAlgorithm = Objects.requireNonNull(sseAlgorithm, "SSE Algorithm must be provided");
    this.kmsMasterKeyId = kmsMasterKeyId;
  }

  public String kmsMasterKeyId() {
    return this.kmsMasterKeyId;
  }

  public SseAlgorithm sseAlgorithm() {
    return this.sseAlgorithm;
  }
}
