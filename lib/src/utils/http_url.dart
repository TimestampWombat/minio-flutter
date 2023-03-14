extension UriX on Uri {
  Builder newBuilder() => Builder(this);
  bool isHttps() => scheme.toLowerCase().startsWith('https://');
}

class Builder {
  final Uri uri;

  Builder(this.uri);

  Uri build() => uri;

  Builder addQueryParameter(String key, String value) {
    uri.queryParameters[key] = value;
    return this;
  }

  Builder addEncodedQueryParameter(String key, String value) {
    uri.queryParameters[key] = value;
    return this;
  }
}
