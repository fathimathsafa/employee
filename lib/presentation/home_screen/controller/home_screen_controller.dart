import 'dart:developer';
import 'package:employee/repository/api/common/model/employee_list_model.dart';
import 'package:employee/repository/api/common/service/user_service.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  List<User> users = [];
  User? selectedUser;
  bool isLoading = false;
  bool isUpdating = false;
  String? errorMessage;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setUpdating(bool value) {
    isUpdating = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    log("UserController -> fetchUsers() started");
    setLoading(true);
    setErrorMessage(null);

    try {
      final userResponse = await UserService.getUsers();

      if (userResponse != null) {
        users = userResponse.users;
        log("Fetched ${users.length} users");
      } else {
        log("Failed to fetch users");
        setErrorMessage("Failed to load employees. Please try again later.");
      }
    } catch (e) {
      log("Error fetching users: $e");
      setErrorMessage("An error occurred while loading employees.");
    } finally {
      setLoading(false);
    }
  }

  Future<User?> fetchUserDetails(int userId) async {
    log("UserController -> fetchUserDetails() for ID: $userId");
    setLoading(true);
    setErrorMessage(null);

    try {
      final user = await UserService.getUserById(userId);

      if (user != null) {
        selectedUser = user;
        log("Fetched details for user ID: $userId");
      } else {
        log("Failed to fetch details for user ID: $userId");
        setErrorMessage("Failed to load employee details. Please try again.");
      }

      return user;
    } catch (e) {
      log("Error fetching user details: $e");
      setErrorMessage("An error occurred while loading employee details.");
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> updateUserDetails(
      int userId,
      {String? firstName, String? lastName, String? phone}
      ) async {
    log("UserController -> updateUserDetails() for ID: $userId");
    setUpdating(true);
    setErrorMessage(null);

    try {
      // Create update payload with only non-null fields
      Map<String, dynamic> updateData = {};

      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;
      if (phone != null) updateData['phone'] = phone;

      final result = await UserService.updateUser(userId, updateData);

      if (result != null && result['id'] != null) {
        // Update the selected user with the new details
        if (selectedUser != null) {
          // Since User is immutable, we need to create a new instance
          // This is just for UI update, as the actual update would happen on the server
          // But since this is a fake update, we're just updating the local state

          // Clone existing user data
          final updatedUser = User(
            id: selectedUser!.id,
            firstName: firstName ?? selectedUser!.firstName,
            lastName: lastName ?? selectedUser!.lastName,
            maidenName: selectedUser!.maidenName,
            age: selectedUser!.age,
            gender: selectedUser!.gender,
            email: selectedUser!.email,
            phone: phone ?? selectedUser!.phone,
            username: selectedUser!.username,
            password: selectedUser!.password,
            birthDate: selectedUser!.birthDate,
            image: selectedUser!.image,
            bloodGroup: selectedUser!.bloodGroup,
            height: selectedUser!.height,
            weight: selectedUser!.weight,
            eyeColor: selectedUser!.eyeColor,
            hair: selectedUser!.hair,
            ip: selectedUser!.ip,
            address: selectedUser!.address,
            macAddress: selectedUser!.macAddress,
            university: selectedUser!.university,
            bank: selectedUser!.bank,
            company: selectedUser!.company,
            ein: selectedUser!.ein,
            ssn: selectedUser!.ssn,
            userAgent: selectedUser!.userAgent,
            crypto: selectedUser!.crypto,
            role: selectedUser!.role,
          );

          selectedUser = updatedUser;
        }

        log("Successfully updated user ID: $userId");
        return true;
      } else {
        log("Failed to update user ID: $userId");
        setErrorMessage("Failed to update employee information.");
        return false;
      }
    } catch (e) {
      log("Error updating user details: $e");
      setErrorMessage("An error occurred while updating employee information.");
      return false;
    } finally {
      setUpdating(false);
    }
  }
}