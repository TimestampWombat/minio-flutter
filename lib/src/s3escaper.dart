 class S3Escaper {
  //  static final Escaper ESCAPER = UrlEscapers.urlPathSegmentEscaper();

  /// Returns S3 encoded string.
   static String encode(String? str) {
    if (str == null) {
      return "";
    }
    return Uri.encodeFull(str);

    // return ESCAPER
    //     .escape(str)
    //     .replaceAll("\\!", "%21")
    //     .replaceAll("\\$", "%24")
    //     .replaceAll("\\&", "%26")
    //     .replaceAll("\\'", "%27")
    //     .replaceAll("\\(", "%28")
    //     .replaceAll("\\)", "%29")
    //     .replaceAll("\\*", "%2A")
    //     .replaceAll("\\+", "%2B")
    //     .replaceAll("\\,", "%2C")
    //     .replaceAll("\\/", "%2F")
    //     .replaceAll("\\:", "%3A")
    //     .replaceAll("\\;", "%3B")
    //     .replaceAll("\\=", "%3D")
    //     .replaceAll("\\@", "%40")
    //     .replaceAll("\\[", "%5B")
    //     .replaceAll("\\]", "%5D");
  }

  /// Returns S3 encoded string of given path where multiple '/' are trimmed.
   static String encodePath(String path) {
    final StringBuffer encodedPath = StringBuffer();
    
     if (path.startsWith("/")) {
      encodedPath.write( "/");
    }

    for (String pathSegment in path.split("/")) {
      if (pathSegment.isNotEmpty) {
        if (encodedPath.length > 0) {
          encodedPath.write("/");
        }
        encodedPath.write(S3Escaper.encode(pathSegment));
      }
    }

   
    if (path.endsWith("/")) {
      encodedPath.write("/");
    }

    return encodedPath.toString();
  }
}
