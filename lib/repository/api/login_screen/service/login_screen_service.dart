import 'dart:developer';
import 'package:employee/repository/helper/api_helper.dart';



class LoginService {
  static Future postLoginData(email, password) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres-free-v1'
      };

      var decodedData = await ApiHelper.postData(
          endPoint: "login",
          body: {
            "email": email,
            "password": password
          },
          headers: headers
      );

      if (decodedData == null) {
        return {"status": 400, "error": "No response from server"};
      }
      return decodedData;
    } catch (e) {
      log("Login Service Error: $e");
      return {"status": 400, "error": "Login failed: ${e.toString()}"};
    }
  }
}