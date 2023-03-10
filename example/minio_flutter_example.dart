import 'dart:io';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:minio_flutter/minio_flutter.dart';
import 'package:xml2json/xml2json.dart';
import 'package:crypto/crypto.dart' as crypto;

void main() async {
  InternetAddress address =
      InternetAddress("1:2:3:4:5:6:7:8", type: InternetAddressType.IPv6);
      
  print(address.type);
  // crypto.Digest sha256Digest = crypto.sha256.convert('Wombat'.codeUnits);
  // print(sha256Digest.toString());
  // print(hex.encode(sha256Digest.bytes));
  String expected =
      "0a0a2f7259506e5a57419c806d4396ddd00c0567f248e24402136762d662acc8";
  String result =
      hex.encode(await sumHmac("Wombat".codeUnits, "Koala".codeUnits));
  print(expected == result);
}

Future<List<int>> sumHmac(List<int> key, List<int> data) async {
  SecretKey secretKey = SecretKey(key);
  Mac mac = await Hmac.sha256().calculateMac(data, secretKey: secretKey);
  return mac.bytes;
}

void mainXml() {
  // Create a client transformer
  final myTransformer = Xml2Json();

  // Parse a simple XML string

  myTransformer.parse(goodXmlString);
  print('XML string');
  print(goodXmlString);
  print('');

  // Transform to JSON using Badgerfish
  var json = myTransformer.toBadgerfish();
  print('Badgerfish');
  print('');
  print(json);
  print('');

  // Transform to JSON using GData
  json = myTransformer.toGData();
  print('GData');
  print('');
  print(json);
  print('');

  // Transform to JSON using Parker
  json = myTransformer.toParker();
  print('Parker');
  print('');
  print(json);
  print('');

  // Transform to JSON using ParkerWithAttrs
  json = myTransformer.toParkerWithAttrs();
  print('ParkerWithAttrs');
  print('');
  print(json);
  print('');

  // Transform to JSON using ParkerWithAttrs
  // A node in XML should be an array, but if there is only one element in the array,
  // it will only be parsed into an object, so we need to specify the node as an array
  json = myTransformer.toParkerWithAttrs(array: ['contact']);
  print('ParkerWithAttrs, specify the node as an array');
  print('');
  print(json);
}

String goodXmlString =
    '<?xml version="1.0" encoding="UTF-8"?><contacts><contact id="1"><name>John Doe</name><phone>123-"456"-7890</phone><address><street>123 JFKStreet</street><city>Any Town</city><state>Any State</state><zipCode>12345</zipCode></address></contact></contacts>';
String goodXmlStringJson =
    '{"contacts" : {"contact" : {"@attributes" : {"id" : "1"}, "name" : "John Doe", "phone" : "123-\\"456\\"-7890", "address" : {"street" : "123 JFK Street", "city" : "Any Town", "state" : "Any State", "zipCode" : "12345"}}}}';
