@Root(name = "JSON")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class JsonOutputSerialization {
  @Element(name = "RecordDelimiter", required = false)
  private Character recordDelimiter;

  /** Constructs a JsonOutputSerialization object. */
  public JsonOutputSerialization(Character recordDelimiter) {
    this.recordDelimiter = recordDelimiter;
  }
}
