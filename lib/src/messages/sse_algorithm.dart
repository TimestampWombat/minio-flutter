@Root(name = "SSEAlgorithm")
@Convert(SseAlgorithm.SseAlgorithmConverter.class)
public enum SseAlgorithm {
  AES256("AES256"),
  AWS_KMS("aws:kms");

  private final String value;

  private SseAlgorithm(String value) {
    this.value = value;
  }

  public String toString() {
    return this.value;
  }

  /** Returns SseAlgorithm of given string. */
  @JsonCreator
  public static SseAlgorithm fromString(String sseAlgorithmString) {
    for (SseAlgorithm sa : SseAlgorithm.values()) {
      if (sseAlgorithmString.equals(sa.value)) {
        return sa;
      }
    }

    throw ArgumentError("unknown SSE algorithm '" + sseAlgorithmString + "'");
  }

  /** XML converter class. */
  public static class SseAlgorithmConverter implements Converter<SseAlgorithm> {
    @Override
    public SseAlgorithm read(InputNode node) throws Exception {
      return SseAlgorithm.fromString(node.getValue());
    }

    @Override
    public void write(OutputNode node, SseAlgorithm sseAlgorithm) throws Exception {
      node.setValue(sseAlgorithm.toString());
    }
  }
}
