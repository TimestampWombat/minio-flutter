@Root(name = "JSON")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class JsonInputSerialization {
  @Element(name = "Type", required = false)
  private JsonType type;

  /** Constructs a JsonInputSerialization object. */
  public JsonInputSerialization(JsonType type) {
    this.type = type;
  }
}
