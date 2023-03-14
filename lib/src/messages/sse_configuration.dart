@Root(name = "ServerSideEncryptionConfiguration")
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class SseConfiguration {
  @Element(name = "Rule", required = false)
  private SseConfigurationRule rule;

  public SseConfiguration(
      @Nullable @Element(name = "Rule", required = false) SseConfigurationRule rule) {
    this.rule = rule;
  }

  public static SseConfiguration newConfigWithSseS3Rule() {
    return SseConfiguration(SseConfigurationRule(SseAlgorithm.AES256, null));
  }

  public static SseConfiguration newConfigWithSseKmsRule(@Nullable String kmsMasterKeyId) {
    return SseConfiguration(SseConfigurationRule(SseAlgorithm.AWS_KMS, kmsMasterKeyId));
  }

  public SseConfigurationRule rule() {
    return this.rule;
  }
}
