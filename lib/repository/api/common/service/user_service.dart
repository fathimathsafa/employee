import 'dart:developer';
import 'package:employee/app_config/app_config.dart';
import 'package:employee/repository/api/common/model/employee_list_model.dart';
import 'package:employee/repository/helper/api_helper.dart';



class UserService {
  static Future<UserResponse?> getUsers() async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres-free-v1'
      };


      var decodedData = await ApiHelper.getDataWObaseUrl(
        endPoint: "${AppConfig.dummyJsonBaseUrl}users",
        headers: headers,
      );

      if (decodedData == null) {
        log("No response from server for users");
        return null;
      }

      return UserResponse.fromJson(decodedData);
    } catch (e) {
      log("User Service Error (getUsers): $e");
      return null;
    }
  }

  static Future<User?> getUserById(int userId) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres-free-v1'
      };


      var decodedData = await ApiHelper.getDataWObaseUrl(
        endPoint: "${AppConfig.dummyJsonBaseUrl}users/$userId",
        headers: headers,
      );

      if (decodedData == null) {
        log("No response from server for user ID: $userId");
        return null;
      }

      return User.fromJson(decodedData);
    } catch (e) {
      log("User Service Error (getUserById): $e");
      return null;
    }
  }

  static Future<Map?> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres-free-v1'
      };


      // Creating a PUT request
      final url = Uri.parse("${AppConfig.dummyJsonBaseUrl}users/$userId");

      // This is a fake PUT request as mentioned in the requirements
      // In real scenarios, we would use http.put
      var decodedData = await ApiHelper.postData(
        endPoint: "users/$userId",
        headers: headers,
        body: userData,
      );

      if (decodedData == null) {
        log("No response from server for updating user ID: $userId");
        return null;
      }

      return decodedData;
    } catch (e) {
      log("User Service Error (updateUser): $e");
      return {"error": e.toString()};
    }
  }
}