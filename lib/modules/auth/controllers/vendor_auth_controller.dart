import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/api/services/vendor_api_service.dart';

class VendorAuthController extends GetxController {
  final VendorApiService _apiService = Get.find<VendorApiService>();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final businessTypeController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register() async {
    if (!_validateForm()) return;
    
    isLoading.value = true;
    try {
      final response = await _apiService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
        businessName: businessNameController.text.trim(),
        businessAddress: businessAddressController.text.trim(),
        businessType: businessTypeController.text.trim(),
      );
      
      if (response.isOk) {
        final message = response.body['message'] ?? 'Vendor account created successfully';
        Get.snackbar('Success', message);
        Get.offAllNamed('/login', arguments: 'vendor');
      } else {
        final errorMessage = response.body['message'] ?? response.body['error'] ?? 'Registration failed';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
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
    if (businessNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Business name is required');
      return false;
    }
    if (businessAddressController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Business address is required');
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
    businessNameController.dispose();
    businessAddressController.dispose();
    businessTypeController.dispose();
    super.onClose();
  }
}