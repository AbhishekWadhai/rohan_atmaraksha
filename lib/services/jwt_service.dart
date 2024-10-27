import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rohan_atmaraksha/app_constants/app_strings.dart';
import 'package:rohan_atmaraksha/services/api_services.dart';
import 'package:rohan_atmaraksha/services/shared_preferences.dart';

Future<bool> isTokenValid() async {
  String? token = await SharedPrefService().getString("token");

  if (token != null && !JwtDecoder.isExpired(token)) {
    Map<String, dynamic>? decodedData = JwtDecoder.tryDecode(token);
    Strings.userId = decodedData?["userId"] ?? "";
    String role = decodedData?["role"] ?? "";
    print(role);
    print(Strings.userId);
    List<dynamic> roles = await ApiService().getRequest("role");
    List<dynamic> user = await ApiService().getRequest("user");
    var userName = user.firstWhere((e) => e["_id"] == Strings.userId, orElse: () => null);
    print(roles);
    var assignedRole =
        roles.firstWhere((e) => e["_id"] == role, orElse: () => null);
    if (userName != null) {
      Strings.userName = userName["name"];
    }
     print(
          "---------------------------------------name-----------------------------------------------------");
    print(Strings.userName);
    if (assignedRole != null) {
      // Store roleName and permissions in variables
      Strings.roleName = assignedRole["roleName"];
      Strings.permisssions = List<String>.from(assignedRole["permissions"]);
      print(Strings.roleName);
      print(
          "--------------------------------------------------------------------------------------------");
      print(Strings.permisssions);
    } else {
      print("Role not found");
    }

    return true;
  } else {
    return false;
  }
}
