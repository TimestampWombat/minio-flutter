@Root(name = "ListBucketResult", strict = false)
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class ListBucketResultV1 extends ListObjectsResult {
  @Element(name = "Marker", required = false)
  private String marker;

  @Element(name = "NextMarker", required = false)
  private String nextMarker;

  @ElementList(name = "Contents", inline = true, required = false)
  private List<Contents> contents;

  public String marker() {
    return decodeIfNeeded(marker);
  }

  public String nextMarker() {
    return decodeIfNeeded(nextMarker);
  }

  @Override
  public List<Contents> contents() {
    return emptyIfNull(contents);
  }
}
