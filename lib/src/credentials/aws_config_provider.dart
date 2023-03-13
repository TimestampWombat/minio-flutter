import 'dart:async';
import 'dart:io';

import '../errors/minio_exception.dart';
import 'credentials.dart';
import 'environment_provider.dart';

class AwsConfigProvider extends EnvironmentProvider {
  final String? filename;
  final String? profile;

  AwsConfigProvider(this.filename, this.profile) {
    if (filename != null && filename!.isEmpty) {
      throw ArgumentError("Filename must not be empty");
    }

    if (profile != null && profile!.isEmpty) {
      throw ArgumentError("Profile must not be empty");
    }
  }

  /// Retrieve credentials in provided profile or AWS_PROFILE or "default" section in INI file from
  /// provided filename or AWS_SHARED_CREDENTIALS_FILE environment variable or file .aws/credentials
  /// in user's home directory.
  /// TODO: 从文件中获取
  @override
  FutureOr<Credentials> fetch() {
    throw UnimplementedError();
  }
}
//     String? filename = this.filename;
//     filename ??= getProperty("AWS_SHARED_CREDENTIALS_FILE");
//     filename ??= Paths.get(System.getProperty("user.home"), ".aws", "credentials").toString();

//     String? profile = this.profile;
//     profile ??= getProperty("AWS_PROFILE");
//     profile ??= "default";

//     try  {
//       File file = File(filename);
//       Map<String, Properties> result = unmarshal(InputStreamReader(is, StandardCharsets.UTF_8));
//       Properties values = result.get(profile);
//       if (values == null) {
//         throw ProviderException(
//             "Profile $profile does not exist in AWS credential file");
//       }

//       String? accessKey = values.getProperty("aws_access_key_id");
//       String? secretKey = values.getProperty("aws_secret_access_key");
//       String? sessionToken = values.getProperty("aws_session_token");

//       if (accessKey == null) {
//         throw ProviderException(
//             "Access key does not exist in profile $profile in AWS credential file");
//       }

//       if (secretKey == null) {
//         throw ProviderException(
//             "Secret key does not exist in profile $profile in AWS credential file");
//       }

//       return Credentials(accessKey, secretKey, sessionToken, null);
//     } catch (e) {
//       throw ProviderException("Unable to read AWS credential file $e");
//     }
//   }

//    Map<String, Properties> unmarshal(Reader reader) throws IOException {
//     return Ini().unmarshal(reader);
//   }
// }

//     class Ini {
//      Map<String, Properties> result = new HashMap<>();

//      Map<String, Properties> unmarshal(Reader reader) throws IOException {
//       new Properties() {
//          Properties section;

//         @Override
//          Object put(Object key, Object value) {
//           String header = (((String) key) + " " + value).trim();
//           if (header.startsWith("[") && header.endsWith("]")) {
//             section = new Properties();
//             return result.put(header.substring(1, header.length() - 1), section);
//           }
//           return section.put(key, value);
//         }

//         @Override
//          boolean equals(Object o) {
//           return super.equals(o);
//         }

//         @Override
//          int hashCode() {
//           return super.hashCode();
//         }
//       }.load(reader);

//       return result;
//     }
//   }

