import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../modules/rider/controllers/rider_controller.dart';
import '../../modules/vendor/controllers/vendor_controller.dart';
import '../../data/api/api_client.dart';
import '../../data/api/endpoints.dart';

class GlobalController extends GetxController {
  final _currentUserRole = 'user'.obs;
  final _isLoggedIn = false.obs;
  final _currentUserId = ''.obs;
  final _userName = ''.obs;
  final _profileId = ''.obs;
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  String get currentUserRole => _currentUserRole.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get currentUserId => _currentUserId.value;
  int get userId {
    final userIdString = _currentUserId.value;
    final parsedUserId = int.tryParse(userIdString) ?? 0;
    debugPrint('🔍 GlobalController.userId getter:');
    debugPrint('   📝 _currentUserId.value: "$userIdString"');
    debugPrint('   🔢 Parsed userId: $parsedUserId');
    return parsedUserId;
  }
  String get userName => _userName.value;
  String get profileId => _profileId.value;
  
  void setUserRole(String role) {
    _currentUserRole.value = role;
  }
  
  void setLoginStatus(bool status) {
    _isLoggedIn.value = status;
  }
  
  void setUserId(String userId) {
    _currentUserId.value = userId;
  }
  
  void setUserName(String name) {
    _userName.value = name;
  }
  
  void setProfileId(String profileId) {
    _profileId.value = profileId;
  }

  void setUserData(Map<String, dynamic> userData) async {
    // Handle both 'id' and 'user_id' fields from API
    final userId = userData['id']?.toString() ?? userData['user_id']?.toString() ?? '';
    
    _currentUserId.value = userId;
    _userName.value = userData['name']?.toString() ?? '';
    _currentUserRole.value = userData['role']?.toString() ?? 'user';
    _isLoggedIn.value = true;

    debugPrint("🔹 Setting user data...");
    debugPrint("📦 Raw userData: $userData");
    debugPrint("🆔 Extracted User ID: ${_currentUserId.value}");
    debugPrint("👤 User Name: ${_userName.value}");
    debugPrint("🎭 User Role: ${_currentUserRole.value}");
    debugPrint("✅ Is Logged In: ${_isLoggedIn.value}");
    debugPrint("🔢 Parsed userId (int): ${int.tryParse(_currentUserId.value)}");

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', _currentUserId.value);
    await prefs.setString('user_name', _userName.value);
    await prefs.setString('user_role', _currentUserRole.value);
    await prefs.setBool('is_logged_in', true);

    // Immediately fetch back for verification
    final savedUserId = prefs.getString('user_id') ?? '';
    final savedUserName = prefs.getString('user_name') ?? '';
    final savedUserRole = prefs.getString('user_role') ?? 'user';
    final savedIsLoggedIn = prefs.getBool('is_logged_in') ?? false;

    debugPrint("🔍 Verifying saved values...");
    debugPrint("🆔 Saved User ID: $savedUserId");
    debugPrint("👤 Saved User Name: $savedUserName");
    debugPrint("🎭 Saved User Role: $savedUserRole");
    debugPrint("✅ Saved Is Logged In: $savedIsLoggedIn");
  }


  void checkAutoLogin() async {
    debugPrint("🔹 Starting checkAutoLogin...");

    final prefs = await SharedPreferences.getInstance();
    debugPrint("✅ SharedPreferences instance loaded");

    final savedUserId = prefs.getString('user_id');
    final savedUserName = prefs.getString('user_name');
    final savedUserRole = prefs.getString('user_role');
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    debugPrint('📦 Retrieved values from SharedPreferences:');
    debugPrint("   🆔 User ID: $savedUserId");
    debugPrint("   👤 User Name: $savedUserName");
    debugPrint("   🎭 User Role: $savedUserRole");
    debugPrint("   ✅ Is Logged In: $isLoggedIn");

    if (isLoggedIn && savedUserId != null && savedUserId.isNotEmpty) {
      debugPrint("🔹 Auto-login possible, restoring user session...");

      _currentUserId.value = savedUserId;
      _userName.value = savedUserName ?? '';
      _currentUserRole.value = savedUserRole ?? 'user';
      _isLoggedIn.value = true;

      debugPrint("✅ Current session restored:");
      debugPrint('  🆔 ${_currentUserId.value}');
      debugPrint("   👤 ${_userName.value}");
      debugPrint("   🎭 ${_currentUserRole.value}");
      debugPrint("   ✅ isLoggedIn: ${_isLoggedIn.value}");

      // Navigate to appropriate home screen
      debugPrint("➡️ Navigated to home screen1234");
      _navigateToHome();

    } else {
      debugPrint("❌ No valid login session found, redirecting to role selector...");
      Get.offAllNamed('/role-selector');
      // Or: Get.offAllNamed('/login');
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
  
  // Test method to verify userId
  void testUserId() {
    debugPrint('🧪 Testing userId functionality:');
    debugPrint('   📝 _currentUserId.value: "${_currentUserId.value}"');
    debugPrint('   🔢 userId getter result: ${userId}');
    debugPrint('   ✅ Is valid (> 0): ${userId > 0}');
  }
  
  Future<void> logout() async {
    try {
      debugPrint('🚪 Starting logout process...');
      debugPrint('🆔 Current User ID: ${_currentUserId.value}');
      debugPrint('🎭 Current Role: ${_currentUserRole.value}');
      
      // Call logout API
      await _apiClient.post(ApiEndpoints.logout, {
        'user_id': _currentUserId.value
      });
      
      // Clear local data
      _isLoggedIn.value = false;
      _currentUserId.value = '';
      _userName.value = '';
      _currentUserRole.value = 'user';
      _profileId.value = '';
      
      debugPrint('🗑️ Cleared local variables');
      
      // Clear SharedPreferences completely
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      debugPrint('🗑️ Cleared SharedPreferences');
      
      // Clear all role-specific controllers
      try {
        Get.delete<VendorController>(force: true);
        debugPrint('🗑️ Cleared VendorController');
      } catch (e) {
        debugPrint('⚠️ VendorController not found: $e');
      }
      
      try {
        Get.delete<RiderController>(force: true);
        debugPrint('🗑️ Cleared RiderController');
      } catch (e) {
        debugPrint('⚠️ RiderController not found: $e');
      }
      
      debugPrint('✅ Logout completed successfully');
      
      // Navigate to login
      Get.offAllNamed('/login');
      
    } catch (e) {
      debugPrint('❌ Logout failed: $e');
      Get.snackbar('Error', 'Logout failed: $e');
    }
  }
}