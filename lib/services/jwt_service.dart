import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rohan_atmaraksha/services/shared_preferences.dart';


Future<bool> isTokenValid() async {
  String? token = await SharedPrefService().getString("token");

  if (token != null && !JwtDecoder.isExpired(token)) {
    return true;
  } else {
    return false;
  }
}
