import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../modules/rider/controllers/rider_controller.dart';
import '../../modules/vendor/controllers/vendor_controller.dart';
import '../../data/api/api_client.dart';
import '../../data/api/endpoints.dart';

class GlobalController extends GetxController {
  final _currentUserRole = 'user'.obs;
  final _isLoggedIn = false.obs;
  final userId = 0.obs;
  final vendorId = 0.obs;
  final riderId = 0.obs;
  final role = ''.obs;

  ApiClient? _apiClient;
  
  @override
  void onInit() {
    super.onInit();
    try {
      _apiClient = Get.find<ApiClient>();
    } catch (e) {
      debugPrint('ApiClient not found: $e');
    }
  }

  String get currentUserRole => _currentUserRole.value;
  bool get isLoggedIn => _isLoggedIn.value;

  void setUserRole(String role) {
    _currentUserRole.value = role;
  }

  void setLoginStatus(bool status) {
    _isLoggedIn.value = status;
  }

  void setUserData(Map<String, dynamic> userData) async {
    // Convert IDs to int safely
    int userIdInt = int.tryParse(userData['profile']['user_id'].toString()) ?? 0;
    int vendorIdInt = int.tryParse(userData['role_data']['vendor_id'].toString()) ?? 0;
    int riderIdInt = int.tryParse(userData['role_data']['rider_id'].toString()) ?? 0;

    userId.value = userIdInt;
    vendorId.value = vendorIdInt;
    riderId.value = riderIdInt;
    role.value = userData['user']['role'].toString();
    _isLoggedIn.value = true;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userIdInt);
    await prefs.setInt('vendor_id', vendorIdInt);
    await prefs.setInt('rider_id', riderIdInt);
    await prefs.setString('role', role.value);
    await prefs.setString('user_role', _currentUserRole.value);
    await prefs.setBool('is_logged_in', true);

    // Verification print
    final savedUserId = prefs.getInt('user_id') ?? 0;
    final savedVendorId = prefs.getInt('vendor_id') ?? 0;
    final savedRiderId = prefs.getInt('rider_id') ?? 0;
    final savedRole = prefs.getString('role') ?? 'user';
    final savedIsLoggedIn = prefs.getBool('is_logged_in') ?? false;

    debugPrint('🆔 Saved User ID: $savedUserId');
    debugPrint('👤 Saved Vendor ID: $savedVendorId');
    debugPrint('👤 Saved Rider ID: $savedRiderId');
    debugPrint('🎭 Saved Role: $savedRole');
    debugPrint('✅ Saved Is Logged In: $savedIsLoggedIn');
  }

   checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint("✅ SharedPreferences instance loaded");

    final savedUserId = prefs.getInt('user_id') ?? 0;
    final savedVendorId = prefs.getInt('vendor_id') ?? 0;
    final savedRole = prefs.getString('role');
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    debugPrint('📦 Retrieved values from SharedPreferences:');
    debugPrint('🆔 User ID: $savedUserId');
    debugPrint('👤 Vendor ID: $savedVendorId');
    debugPrint('🎭 Role: $savedRole');
    debugPrint('✅ Is Logged In: $isLoggedIn');

    if (isLoggedIn && savedUserId != 0) {
      debugPrint('🔹 Auto-login possible, restoring session...');

      _currentUserRole.value = savedRole ?? 'user';
      _isLoggedIn.value = true;

      debugPrint('✅ Current session restored');
      _navigateToHome();
    } else {
      debugPrint('❌ No valid login session found, redirecting...');
      Get.offAllNamed('/role-selector');
    }
  }

  void _navigateToHome() {
    switch (_currentUserRole.value) {
      case 'user':
        Get.offAllNamed('/home');
        break;
      case 'vendor':
        Get.offAllNamed('/vendor-dashboard');
        break;
      case 'rider':
        Get.offAllNamed('/rider-dashboard');
        break;
      default:
        Get.offAllNamed('/home');
    }
  }

  Future<void> logout() async {
    try {
      debugPrint('🚪 Starting logout process...');
      debugPrint('🎭 Current Role: ${_currentUserRole.value}');

      // Call logout API if available
      if (_apiClient != null) {
        await _apiClient!.post(ApiEndpoints.logout, {'user_id': ""});
      }

      debugPrint('🗑️ Clearing local variables and SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      try {
        Get.delete<VendorController>(force: true);
        debugPrint('🗑️ VendorController cleared');
      } catch (e) {
        debugPrint('⚠️ VendorController not found: $e');
      }

      try {
        Get.delete<RiderController>(force: true);
        debugPrint('🗑️ RiderController cleared');
      } catch (e) {
        debugPrint('⚠️ RiderController not found: $e');
      }

      debugPrint('✅ Logout completed successfully');
      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint('❌ Logout failed: $e');
      Get.snackbar('Error', 'Logout failed: $e');
    }
  }
}
