@Root(name = "OutputSerialization")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class OutputSerialization {
  @Element(name = "CSV", required = false)
  private CsvOutputSerialization csv;

  @Element(name = "JSON", required = false)
  private JsonOutputSerialization json;

  /** Constructs a OutputSerialization object with CSV. */
  public OutputSerialization(
      Character fieldDelimiter,
      Character quoteCharacter,
      Character quoteEscapeCharacter,
      QuoteFields quoteFields,
      Character recordDelimiter) {
    this.csv =
        CsvOutputSerialization(
            fieldDelimiter, quoteCharacter, quoteEscapeCharacter, quoteFields, recordDelimiter);
  }

  /** Constructs a OutputSerialization object with JSON. */
  public OutputSerialization(Character recordDelimiter) {
    this.json = JsonOutputSerialization(recordDelimiter);
  }
}
