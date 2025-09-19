import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/controllers/global_controller.dart';
import '../../data/api/api_client.dart';
import '../../data/api/services/user_api_service.dart';
import '../../data/api/services/vendor_api_service.dart';
import '../../data/api/services/rider_api_service.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../vendor/controllers/vendor_controller.dart';
import '../vendor/repositories/vendor_repository.dart';
import '../rider/controllers/rider_controller.dart';
import '../rider/repositories/rider_repository.dart';
import '../address/repositories/address_repository.dart';
import '../../data/api/services/profile_api_service.dart';
import '../wallet/repositories/wallet_repository.dart';

class LoginController extends GetxController {
  GlobalController? _globalController;
  
  @override
  void onInit() {
    super.onInit();
    try {
      _globalController = Get.find<GlobalController>();
      print('GlobalController found successfully');
    } catch (e) {
      print('GlobalController not found: $e');
    }
    
    final role = Get.arguments as String?;
    if (role != null) {
      _selectedRole.value = role;
      print('Role set from arguments: $role');
    }
  }
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final _isPasswordVisible = false.obs;
  final _isLoading = false.obs;
  final _selectedRole = 'user'.obs;

  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  String get selectedRole => _selectedRole.value;

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Future<void> onLogin() async {
    print('=== LOGIN ATTEMPT ===');
    print('Email: ${emailController.text}');
    print('Role: ${_selectedRole.value}');
    
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      print('ERROR: Empty fields');
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    _isLoading.value = true;
    try {
      Response? response;
      print('Attempting login for role: ${_selectedRole.value}');
      
      switch (_selectedRole.value) {
        case 'user':
          print('Getting UserApiService...');
          final userService = Get.find<UserApiService>();
          print('Calling user login API...');
          response = await userService.login(
            email: emailController.text,
            password: passwordController.text,
          );
          print(' user Login response ...$response');
          break;
        case 'vendor':
          print('Getting VendorApiService...');
          final vendorService = Get.find<VendorApiService>();
          print('Calling vendor login API...');
          response = await vendorService.login(
            email: emailController.text,
            password: passwordController.text,
          );
          break;
        case 'rider':
          print('Getting RiderApiService...');
          final riderService = Get.find<RiderApiService>();
          print('Calling rider login API...');
          response = await riderService.login(
            email: emailController.text,
            password: passwordController.text,
          );
          break;
      }

      print('Response received:');
      print('Status Code: ${response?.statusCode}');
      print('Is OK: ${response?.isOk}');
      print('Body: ${response?.body}');
      print('Status Text: ${response?.statusText}');

      if (response?.isOk == true) {
        print('Login successful, setting user data...');
        
        print('Login response body: ${response!.body}');
        
        if (_globalController != null) {
          final userData = response.body['data'] ?? response.body;
          _globalController!.setUserData(userData);
          
          // Initialize role-specific controllers after login
          await _initializeRoleControllers();
          
          // Verify after setting
          print('🔍 After setUserData:');
          print('   🔢 GlobalController.userId: ${_globalController!.userId}');

        } else {
          print('GlobalController is null, skipping user data setting');
        }
        
        final successMessage = response.body['message'] ?? 'Logged in successfully';
        Get.snackbar('Success', successMessage);
        _navigateBasedOnRole();
      } else {
        print('Login failed with response: ${response?.body}');
        final errorMessage = response?.body['message'] ?? response?.body['error'] ?? 'Login failed';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e, stackTrace) {
      print('EXCEPTION during login:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      _isLoading.value = false;
      print('=== LOGIN ATTEMPT END ===');
    }
  }

  Future<void> _initializeRoleControllers() async {
    try {
      // Initialize API client FIRST - required by all other services
      if (!Get.isRegistered<ApiClient>()) {
        Get.put(ApiClient());
      }
      
      // Initialize common dependencies
      if (!Get.isRegistered<GlobalController>()) {
        Get.put(GlobalController());
      }
      
      // Initialize common repositories needed by all roles
      if (!Get.isRegistered<AddressRepository>()) {
        Get.put(AddressRepository());
      }
      
      if (!Get.isRegistered<ProfileApiService>()) {
        Get.put(ProfileApiService());
      }
      
      if (!Get.isRegistered<WalletRepository>()) {
        Get.put(WalletRepository());
      }
      
      // Initialize role-specific controllers
      switch (_selectedRole.value) {
        case 'vendor':
          if (!Get.isRegistered<VendorRepository>()) {
            Get.put(VendorRepository());
          }
          if (!Get.isRegistered<VendorController>()) {
            Get.put(VendorController());
          }
          break;
        case 'rider':
          if (!Get.isRegistered<RiderRepository>()) {
            Get.put(RiderRepository());
          }
          if (!Get.isRegistered<RiderController>()) {
            Get.put(RiderController());
          }
          break;
        case 'user':
          // User-specific repositories are already initialized above
          break;
      }
      
      print('Role-specific controllers initialized for: ${_selectedRole.value}');
    } catch (e) {
      print('Error initializing role controllers: $e');
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
