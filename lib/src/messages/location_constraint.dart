@Root(name = "LocationConstraint", strict = false)
@Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
public class LocationConstraint {
  @Text(required = false)
  private String location = "";

  public LocationConstraint() {}

  public String location() {
    return location;
  }
}
