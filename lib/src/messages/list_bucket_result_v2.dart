@Root(name = "ListBucketResult", strict = false)
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class ListBucketResultV2 extends ListObjectsResult {
  @Element(name = "KeyCount", required = false)
  private int keyCount;

  @Element(name = "StartAfter", required = false)
  private String startAfter;

  @Element(name = "ContinuationToken", required = false)
  private String continuationToken;

  @Element(name = "NextContinuationToken", required = false)
  private String nextContinuationToken;

  @ElementList(name = "Contents", inline = true, required = false)
  private List<Contents> contents;

  /** Returns key count. */
  public int keyCount() {
    return keyCount;
  }

  /** Returns start after. */
  public String startAfter() {
    return decodeIfNeeded(startAfter);
  }

  /** Returns continuation token. */
  public String continuationToken() {
    return continuationToken;
  }

  /** Returns next continuation token. */
  public String nextContinuationToken() {
    return nextContinuationToken;
  }

  /** Returns List of Items. */
  @Override
  public List<Contents> contents() {
    return emptyIfNull(contents);
  }
}
