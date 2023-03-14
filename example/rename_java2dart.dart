import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;

void main() {
  Directory directory = Directory(
      "/Users/wombat/FlutterProjects/side-projects/minio-flutter/lib/src/messages");
  directory.listSync().forEach((element) {
    if (element is File) {
      if (path.extension(element.path) == ".java") {
        changeName(element);
        element.deleteSync();
      }
    }
  });
  // print(changeName(File(
  //     "/Users/wombat/FlutterProjects/side-projects/minio-flutter/lib/src/messages/AccessControlList.java")));
}

String changeName(File file) {
  String name = path.basenameWithoutExtension(file.path);
  String newName = name
      .replaceAllMapped(
          RegExp(r'[A-Z]'), (match) => "_${match.group(0)?.toLowerCase()}")
      .substring(1);
  File dartFile = File('${path.dirname(file.path)}/$newName.dart');
  String content = file.readAsStringSync();
  dartFile.writeAsStringSync(content.substring(max(content.indexOf("@Root"), 0)));
  return newName;
}
