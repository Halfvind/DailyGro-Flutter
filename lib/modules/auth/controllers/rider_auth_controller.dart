import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/api/services/rider_api_service.dart';

class RiderAuthController extends GetxController {
  final RiderApiService _apiService = Get.find<RiderApiService>();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final addressController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final selectedVehicleType = 'Motorcycle'.obs;
  
  final vehicleTypes = ['Motorcycle', 'Bicycle', 'Car', 'Scooter'];

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void setVehicleType(String type) {
    selectedVehicleType.value = type;
    vehicleTypeController.text = type;
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
        vehicleType: selectedVehicleType.value,
        licenseNumber: licenseNumberController.text.trim(),
        address: addressController.text.trim(),
      );
      
      if (response.isOk) {
        final message = response.body['message'] ?? 'Rider account created successfully';
        Get.snackbar('Success', message);
        Get.offAllNamed('/login', arguments: 'rider');
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
    if (licenseNumberController.text.trim().isEmpty) {
      Get.snackbar('Error', 'License number is required');
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
    vehicleTypeController.dispose();
    licenseNumberController.dispose();
    addressController.dispose();
    super.onClose();
  }
}