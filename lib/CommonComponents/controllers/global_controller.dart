import 'package:get/get.dart';

import '../../modules/rider/controllers/rider_controller.dart';
import '../../modules/vendor/controllers/vendor_controller.dart';

class GlobalController extends GetxController {
  final _currentUserRole = 'user'.obs;
  final _isLoggedIn = false.obs;
  final _currentUserId = ''.obs;
  final _userName = ''.obs;
  
  String get currentUserRole => _currentUserRole.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get currentUserId => _currentUserId.value;
  String get userName => _userName.value;
  
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
  
  void setUserData(Map<String, dynamic> userData) {
    _currentUserId.value = userData['id'] ?? '';
    _userName.value = userData['name'] ?? '';
    _currentUserRole.value = userData['role'] ?? 'user';
    _isLoggedIn.value = true;
  }
  
  Future<void> logout() async {
    try {
      _isLoggedIn.value = false;
      _currentUserId.value = '';
      _userName.value = '';
      _currentUserRole.value = 'user';
      
      // Navigate to splash screen first, then to role selector
      Get.offAllNamed('/splash');
      
      // Clear controllers after navigation
      await Future.delayed(const Duration(milliseconds: 100));
      Get.delete<VendorController>(force: true);
      Get.delete<RiderController>(force: true);
    } catch (e) {
      Get.snackbar('Error', 'Logout failed');
    }
  }
}