@Root(name = "Expiration")
public class Expiration extends DateDays {
  @Element(name = "ExpiredObjectDeleteMarker", required = false)
  private Boolean expiredObjectDeleteMarker;

  public Expiration(
      @Nullable @Element(name = "Date", required = false) ResponseDate date,
      @Nullable @Element(name = "Days", required = false) Integer days,
      @Nullable @Element(name = "ExpiredObjectDeleteMarker", required = false)
          Boolean expiredObjectDeleteMarker) {
    if (expiredObjectDeleteMarker != null) {
      if (date != null || days != null) {
        throw ArgumentError(
            "ExpiredObjectDeleteMarker must not be provided along with Date and Days");
      }
    } else if (date != null ^ days != null) {
      this.date = date;
      this.days = days;
    } else {
      throw ArgumentError("Only one of date or days must be set");
    }

    this.expiredObjectDeleteMarker = expiredObjectDeleteMarker;
  }

  public Expiration(ZonedDateTime date, Integer days, Boolean expiredObjectDeleteMarker) {
    this(date == null ? null : ResponseDate(date), days, expiredObjectDeleteMarker);
  }

  public Boolean expiredObjectDeleteMarker() {
    return expiredObjectDeleteMarker;
  }
}
