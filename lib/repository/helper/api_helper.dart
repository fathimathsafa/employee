import 'dart:convert';
import 'dart:developer';
import 'package:employee/app_config/app_config.dart';
import 'package:http/http.dart' as http;


class ApiHelper {
  static postData({
    required String endPoint,
    Map<String, String>? headers,
    Map? body,
  }) async {
    log("input $body");
    final url = Uri.parse(AppConfig.baseurl + endPoint);
    log("$url -> url");
    try {
      var response = await http.post(
        url,
        body: body != null ? jsonEncode(body) : null, // Encode the body to JSON
        headers: headers,
      );
      log("StatusCode -> ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        log("Api Failed");
        var data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      }
    } catch (e) {
      log("$e");
      return {"error": e.toString()}; // Return error information
    }
  }

  static getData({
    required String endPoint,
    Map<String, String>? headers, // Changed from Map? header
  }) async {
    log("ApiHelper -> getData");
    final url = Uri.parse(AppConfig.baseurl + endPoint);
    log("url -> $url");
    try {
      var response = await http.get(url, headers: headers);
      log("getData -> Status code -> ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedData = jsonDecode(response.body);
        return decodedData;
      } else {
        log("Else Condition >> Api failed");
      }
    } catch (e) {
      log("$e");
    }
  }

  static getDataWObaseUrl({
    required String endPoint,
    Map<String, String>? headers, // Changed from Map? header
  }) async {
    log("ApiHelper -> getData");
    final url = Uri.parse(endPoint);
    log("url -> $url");
    try {
      var response = await http.get(url, headers: headers);
      log("getData -> Status code -> ${response.statusCode}");
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        return decodedData;
      } else {
        log("Else Condition >> Api failed");
      }
    } catch (e) {
      log("$e");
    }
  }

  static Map<String, String> getApiHeader({String? access, String? dbName}) {
    // Changed return type
    if (access != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access'
      };
    } else if (dbName != null) {
      return {'Content-Type': 'application/json', 'dbName': dbName};
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }
}
