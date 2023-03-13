import 'package:http/http.dart';

extension ResponseX on BaseResponse{
  bool isSuccessful() => statusCode ~/ 200 == 1;

  bool notSuccessful() => !isSuccessful();
}
