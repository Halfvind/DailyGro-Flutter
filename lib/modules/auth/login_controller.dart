import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/controllers/global_controller.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final GlobalController _globalController = Get.find<GlobalController>();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final _isPasswordVisible = false.obs;
  final _isLoading = false.obs;
  final _selectedRole = 'user'.obs;

  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  String get selectedRole => _selectedRole.value;

  @override
  void onInit() {
    super.onInit();
    final role = Get.arguments as String?;
    if (role != null) {
      _selectedRole.value = role;
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Future<void> onLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    _isLoading.value = true;
    try {
      final result = await _authRepository.login(
        emailController.text,
        passwordController.text,
        _selectedRole.value,
      );

      if (result != null) {
        _globalController.setUserData(result['user']);
        _navigateBasedOnRole();
        Get.snackbar('Success', 'Logged in successfully');
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  void _navigateBasedOnRole() {
    switch (_selectedRole.value) {
      case 'vendor':
        Get.offAllNamed('/vendor/dashboard');
        break;
      case 'rider':
        Get.offAllNamed('/rider/dashboard');
        break;
      default:
        Get.offAllNamed(Routes.bottomBar);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
