@Root(name = "InputSerialization")
@edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
public class InputSerialization {
  @Element(name = "CompressionType", required = false)
  private CompressionType compressionType;

  @Element(name = "CSV", required = false)
  private CsvInputSerialization csv;

  @Element(name = "JSON", required = false)
  private JsonInputSerialization json;

  @Element(name = "Parquet", required = false)
  private ParquetInputSerialization parquet;

  /** Constructs a InputSerialization object with CSV. */
  public InputSerialization(
      CompressionType compressionType,
      boolean allowQuotedRecordDelimiter,
      Character comments,
      Character fieldDelimiter,
      FileHeaderInfo fileHeaderInfo,
      Character quoteCharacter,
      Character quoteEscapeCharacter,
      Character recordDelimiter) {
    this.compressionType = compressionType;
    this.csv =
        CsvInputSerialization(
            allowQuotedRecordDelimiter,
            comments,
            fieldDelimiter,
            fileHeaderInfo,
            quoteCharacter,
            quoteEscapeCharacter,
            recordDelimiter);
  }

  /** Constructs a InputSerialization object with JSON. */
  public InputSerialization(CompressionType compressionType, JsonType type) {
    this.compressionType = compressionType;
    this.json = JsonInputSerialization(type);
  }

  /** Constructs a InputSerialization object with Parquet. */
  public InputSerialization() {
    this.parquet = ParquetInputSerialization();
  }
}
