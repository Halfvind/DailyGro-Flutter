import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/api/services/user_api_service.dart';

class UserAuthController extends GetxController {
  final UserApiService _apiService = Get.find<UserApiService>();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register() async {
    print('=== USER REGISTRATION ATTEMPT ===');
    if (!_validateForm()) return;
    
    isLoading.value = true;
    try {
      print('Calling registration API...');
      final response = await _apiService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
      );
      
      print('Registration response:');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      
      if (response.isOk) {
        final message = response.body['message'] ?? 'Account created successfully';
        Get.snackbar('Success', message);
        Get.offAllNamed('/login', arguments: 'user');
      } else {
        final errorMessage = response.body['message'] ?? response.body['error'] ?? 'Registration failed';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e, stackTrace) {
      print('Registration error: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Name is required');
      return false;
    }
    if (emailController.text.trim().isEmpty || !GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Error', 'Valid email is required');
      return false;
    }
    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Phone number is required');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}