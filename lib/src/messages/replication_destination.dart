@Root(name = "Destination")
public class ReplicationDestination {
  @Element(name = "AccessControlTranslation", required = false)
  private AccessControlTranslation accessControlTranslation;

  @Element(name = "Account", required = false)
  private String account;

  @Element(name = "Bucket")
  private String bucketArn;

  @Element(name = "EncryptionConfiguration", required = false)
  private EncryptionConfiguration encryptionConfiguration;

  @Element(name = "Metrics", required = false)
  private Metrics metrics;

  @Element(name = "ReplicationTime", required = false)
  private ReplicationTime replicationTime;

  @Element(name = "StorageClass", required = false)
  private String storageClass;

  public ReplicationDestination(
      @Nullable @Element(name = "AccessControlTranslation", required = false)
          AccessControlTranslation accessControlTranslation,
      @Nullable @Element(name = "Account", required = false) String account,
      @Nonnull @Element(name = "Bucket") String bucketArn,
      @Nullable @Element(name = "EncryptionConfiguration", required = false)
          EncryptionConfiguration encryptionConfiguration,
      @Nullable @Element(name = "Metrics", required = false) Metrics metrics,
      @Nullable @Element(name = "ReplicationTime", required = false)
          ReplicationTime replicationTime,
      @Nullable @Element(name = "StorageClass", required = false) String storageClass) {
    this.accessControlTranslation = accessControlTranslation;
    this.account = account;
    this.bucketArn = Objects.requireNonNull(bucketArn, "Bucket ARN must not be null");
    this.encryptionConfiguration = encryptionConfiguration;
    this.metrics = metrics;
    this.replicationTime = replicationTime;
    this.storageClass = storageClass;
  }

  public AccessControlTranslation accessControlTranslation() {
    return this.accessControlTranslation;
  }

  public String account() {
    return this.account;
  }

  public String bucketArn() {
    return this.bucketArn;
  }

  public EncryptionConfiguration encryptionConfiguration() {
    return encryptionConfiguration;
  }

  public Metrics metrics() {
    return this.metrics;
  }

  public ReplicationTime replicationTime() {
    return this.replicationTime;
  }

  public String storageClass() {
    return this.storageClass;
  }
}
