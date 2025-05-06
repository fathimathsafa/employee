import 'dart:convert';
import 'dart:developer';
import 'package:employee/app_config/app_config.dart';
import 'package:employee/core/utils/app_utils.dart';
import 'package:employee/presentation/home_screen/view/home_screen.dart';
import 'package:employee/repository/api/login_screen/service/login_screen_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  bool visibility = true;
  bool isLoading = false;
  late SharedPreferences _sharedPreferences;

  /// Sets loading state and notifies listeners
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// Handles the login process
  /// 
  /// Takes [email] and [password] from form and attempts to authenticate
  Future<void> onLogin(String email, String password, BuildContext context) async {
    log("loginController -> onLogin() started");

    // Validate input fields
    if (email.isEmpty || password.isEmpty) {
      AppUtils.showToast(
        "Username and Password are required",
        context: context,
      );
      return;
    }

    // Start loading state
    setLoading(true);

    try {
      // Attempt login
      final response = await LoginService.postLoginData(email, password);
      log("postLoginData() response: $response");

      // Handle response
      if (response != null && response["token"] != null) {
        // Store user data and navigate to home screen
        await _storeLoginData(response);
        await _storeUserToken(response["token"]);

        AppUtils.showToast("Logged In Successfully", context: context);
        
        // Navigate to home screen and clear previous routes
        _navigateToHome(context);
      } else {
        // Handle error response
        String errorMessage = response["error"] ?? "Login failed. Please try again.";
        AppUtils.showToast(errorMessage, context: context);
      }
    } catch (e) {
      // Handle exceptions
      AppUtils.showToast("An error occurred. Please try again.", context: context);
      log("Login error: $e");
    } finally {
      // Reset loading state
      setLoading(false);
    }
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    visibility = !visibility;
    notifyListeners();
  }

  /// Stores login data in shared preferences
  Future<void> _storeLoginData(Map<String, dynamic> loginData) async {
    log("storeLoginData()");
    _sharedPreferences = await SharedPreferences.getInstance();
    String storeData = jsonEncode(loginData);
    await _sharedPreferences.setString(AppConfig.loginData, storeData);
    await _sharedPreferences.setBool(AppConfig.loggedIn, true);
  }

  /// Stores user token in shared preferences
  Future<void> _storeUserToken(String token) async {
    log("storeUserToken");
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString(AppConfig.token, token);
  }
  
  /// Navigates to the home screen and clears previous routes
  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false
    );
  }
}