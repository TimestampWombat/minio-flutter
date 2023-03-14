@Root(name = "ListAllMyBucketsResult", strict = false)
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class ListAllMyBucketsResult {
  @Element(name = "Owner")
  private Owner owner;

  @ElementList(name = "Buckets")
  private List<Bucket> buckets;

  public ListAllMyBucketsResult() {}

  /** Returns owner. */
  public Owner owner() {
    return owner;
  }

  /** Returns List of buckets. */
  public List<Bucket> buckets() {
    if (buckets == null) {
      return Collections.unmodifiableList(LinkedList<>());
    }

    return Collections.unmodifiableList(buckets);
  }
}
