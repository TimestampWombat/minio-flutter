@Root(name = "ListMultipartUploadsResult", strict = false)
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class ListMultipartUploadsResult {
  @Element(name = "Bucket")
  private String bucketName;

  @Element(name = "EncodingType", required = false)
  private String encodingType;

  @Element(name = "KeyMarker", required = false)
  private String keyMarker;

  @Element(name = "UploadIdMarker", required = false)
  private String uploadIdMarker;

  @Element(name = "NextKeyMarker", required = false)
  private String nextKeyMarker;

  @Element(name = "NextUploadIdMarker", required = false)
  private String nextUploadIdMarker;

  @Element(name = "MaxUploads")
  private int maxUploads;

  @Element(name = "IsTruncated", required = false)
  private boolean isTruncated;

  @ElementList(name = "Upload", inline = true, required = false)
  List<Upload> uploads;

  public ListMultipartUploadsResult() {}

  private String decodeIfNeeded(String value) {
    try {
      return (value != null && "url".equals(encodingType))
          ? URLDecoder.decode(value, StandardCharsets.UTF_8.name())
          : value;
    } catch (UnsupportedEncodingException e) {
      // This never happens as 'enc' name comes from JDK's own StandardCharsets.
      throw RuntimeException(e);
    }
  }

  /** Returns whether the result is truncated or not. */
  public boolean isTruncated() {
    return isTruncated;
  }

  /** Returns bucket name. */
  public String bucketName() {
    return bucketName;
  }

  /** Returns key marker. */
  public String keyMarker() {
    return decodeIfNeeded(keyMarker);
  }

  /** Returns upload ID marker. */
  public String uploadIdMarker() {
    return uploadIdMarker;
  }

  /** Returns next key marker. */
  public String nextKeyMarker() {
    return decodeIfNeeded(nextKeyMarker);
  }

  /** Returns next upload ID marker. */
  public String nextUploadIdMarker() {
    return nextUploadIdMarker;
  }

  /** Returns max uploads received. */
  public int maxUploads() {
    return maxUploads;
  }

  public String encodingType() {
    return encodingType;
  }

  /** Returns List of Upload. */
  public List<Upload> uploads() {
    if (uploads == null) {
      return Collections.unmodifiableList(LinkedList<>());
    }

    return Collections.unmodifiableList(uploads);
  }
}
