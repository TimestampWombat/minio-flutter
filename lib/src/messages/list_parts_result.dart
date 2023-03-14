@Root(name = "ListPartsResult", strict = false)
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class ListPartsResult {
  @Element(name = "Bucket")
  private String bucketName;

  @Element(name = "Key")
  private String objectName;

  @Element(name = "Initiator")
  private Initiator initiator;

  @Element(name = "Owner")
  private Owner owner;

  @Element(name = "StorageClass")
  private String storageClass;

  @Element(name = "PartNumberMarker")
  private int partNumberMarker;

  @Element(name = "NextPartNumberMarker")
  private int nextPartNumberMarker;

  @Element(name = "MaxParts")
  private int maxParts;

  @Element(name = "IsTruncated")
  private boolean isTruncated;

  @ElementList(name = "Part", inline = true, required = false)
  private List<Part> partList;

  public ListPartsResult() {}

  /** Returns bucket name. */
  public String bucketName() {
    return bucketName;
  }

  /** Returns object name. */
  public String objectName() {
    return objectName;
  }

  /** Returns storage class. */
  public String storageClass() {
    return storageClass;
  }

  /** Returns initator information. */
  public Initiator initiator() {
    return initiator;
  }

  /** Returns owner information. */
  public Owner owner() {
    return owner;
  }

  /** Returns maximum parts information received. */
  public int maxParts() {
    return maxParts;
  }

  /** Returns whether the result is truncated or not. */
  public boolean isTruncated() {
    return isTruncated;
  }

  /** Returns part number marker. */
  public int partNumberMarker() {
    return partNumberMarker;
  }

  /** Returns next part number marker. */
  public int nextPartNumberMarker() {
    return nextPartNumberMarker;
  }

  /** Returns List of Part. */
  public List<Part> partList() {
    if (partList == null) {
      return Collections.unmodifiableList(LinkedList<>());
    }

    return Collections.unmodifiableList(partList);
  }
}
