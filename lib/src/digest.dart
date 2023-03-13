import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto show Digest;
import 'package:crypto/crypto.dart' hide Digest;

import 'package:minio_flutter/src/errors/minio_exception.dart';

class Digest {
  // MD5 hash of zero length byte array.
  static final ZERO_MD5_HASH = "1B2M2Y8AsgTpgAmY7PhCfg==";
  // SHA-256 hash of zero length byte array.
  static final ZERO_SHA256_HASH =
      "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";

  /// constructor.

  /// Returns MD5 hash of byte array.
  static String md5Hash(List<int> data, int length) {
    crypto.Digest md5Digest = md5.convert(data.sublist(0, length));
    return base64.encode(md5Digest.bytes);
  }

  /// Returns SHA-256 hash of byte array.
  static String sha256Hash(List<int> data, int length) {
    crypto.Digest sha256Digest = sha256.convert(data.sublist(0, length));
    return sha256Digest.toString();
  }

  /// Returns SHA-256 hash of given string.
  static String sha256HashFromString(String string) {
    List<int> data = string.codeUnits;
    return sha256Hash(data, data.length);
  }

  /// Returns SHA-256 and MD5 hashes of given data and it's length.
  ///
  /// @param data must be {@link RandomAccessFile}, {@link BufferedInputStream} or byte array.
  /// @param len length of data to be read for hash calculation.
  /// @deprecated This method is no longer supported.
  static List<String> sha256Md5Hashes(Object data, int len) {
    final sha256Output = AccumulatorSink<crypto.Digest>();
    ByteConversionSink sha256Digest =
        sha256.startChunkedConversion(sha256Output);

    final md5Output = AccumulatorSink<crypto.Digest>();
    ByteConversionSink md5Digest = md5.startChunkedConversion(md5Output);

    if (data is RandomAccessFile) {
      updateDigests(data, len, sha256Digest, md5Digest);
    } else if (data is List<int>) {
      sha256Digest.add(data.sublist(0, len));
      md5Digest.add(data.sublist(0, len));
    } else {
      throw InternalException(
          "Unknown data source to calculate SHA-256 hash. This should not happen, "
          "please report this issue at https://github.com/minio/minio-java/issues",
          null);
    }

    final result = <String>[
      sha256Output.events.single.bytes.toString(),
      md5Output.events.single.bytes.toString()
    ];
    sha256Digest.close();
    md5Digest.close();
    sha256Output.close();
    md5Output.close();
    return result;
  }

  /// Updated MessageDigest with bytes read from file and stream.
  static int updateDigests(RandomAccessFile file, int len,
      ByteConversionSink sha256Digest, ByteConversionSink md5Digest) {
    int blockSize = 16 * 1024;
    int totalBytesRead = 0;
    while ((file.positionSync()) < len) {
      try {
        List<int> bytes = file.readSync(blockSize);
        totalBytesRead += bytes.length;
        sha256Digest.add((bytes));
        md5Digest.add(bytes);
      } catch (e) {
        throw InsufficientDataException(
            "Insufficient data.  bytes read $totalBytesRead expected $len");
      }
    }
    file.close();
    return len;
  }
  //  static int updateDigestsOld(
  //     Object inputStream, int len, ByteConversionSink sha256Digest, ByteConversionSink md5Digest)
  //    {
  //   RandomAccessFile file = null;
  //   BufferedInputStream stream = null;
  //   if (inputStream instanceof RandomAccessFile) {
  //     file = (RandomAccessFile) inputStream;
  //   } else if (inputStream instanceof BufferedInputStream) {
  //     stream = (BufferedInputStream) inputStream;
  //   }

  //   // hold current position of file/stream to reset back to this position.
  //   int pos = 0;
  //   if (file != null) {
  //     pos = file.getFilePointer();
  //   } else {
  //     stream.mark(len);
  //   }
  //   // 16KiB buffer for optimization
  //   List<int> buf = byte[16384];
  //   int bytesToRead = buf.length;
  //   int bytesRead = 0;
  //   int totalBytesRead = 0;
  //   while (totalBytesRead < len) {
  //     if ((len - totalBytesRead) < bytesToRead) {
  //       bytesToRead = len - totalBytesRead;
  //     }

  //     if (file != null) {
  //       bytesRead = file.read(buf, 0, bytesToRead);
  //     } else {
  //       bytesRead = stream.read(buf, 0, bytesToRead);
  //     }

  //     if (bytesRead < 0) {
  //       // reached EOF
  //       throw InsufficientDataException(
  //           "Insufficient data.  bytes read " + totalBytesRead + " expected " + len);
  //     }

  //     if (bytesRead > 0) {
  //       if (sha256Digest != null) {
  //         sha256Digest.update(buf, 0, bytesRead);
  //       }

  //       if (md5Digest != null) {
  //         md5Digest.update(buf, 0, bytesRead);
  //       }

  //       totalBytesRead += bytesRead;
  //     }
  //   }

  //   // reset back to saved position.
  //   if (file != null) {
  //     file.seek(pos);
  //   } else {
  //     stream.reset();
  //   }

  //   return totalBytesRead;
  // }
}
