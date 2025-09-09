import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../data/api/services/profile_api_service.dart';
import '../../../models/user_model.dart';

class ProfileController extends GetxController {
  ProfileApiService? _profileApiService;
  GlobalController? _globalController;
  
  final isLoading = false.obs;
  final userProfile = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }
  
  @override
  void onReady() {
    super.onReady();
    if (_profileApiService != null && _globalController != null) {
      loadUserProfile();
    }
  }
  
  void _initializeServices() {
    try {
      _profileApiService = Get.find<ProfileApiService>();
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('Error initializing services: $e');
      // Retry after a delay
      Future.delayed(Duration(milliseconds: 500), () {
        _initializeServices();
      });
    }
  }

  Future<void> loadUserProfile() async {
    if (_globalController == null || _profileApiService == null) {
      print('Services not initialized yet');
      return;
    }
    
    final userId = _globalController!.currentUserId;
    if (userId.isEmpty) {
      Get.snackbar('Error', 'User ID not found');
      return;
    }

    print('Loading profile for user ID: $userId');
    isLoading.value = true;
    
    try {
      final response = await _profileApiService!.getUserProfile(userId);
      
      print('Profile API Response:');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      
      if (response.isOk) {
        final userModel = UserModel.fromProfileResponse(response.body);
        userProfile.value = userModel;
        print('Profile loaded successfully');
      } else {
        final errorMessage = response.body['message'] ?? 'Failed to load profile';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e, stackTrace) {
      print('Profile loading error: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_globalController == null || _profileApiService == null) {
      Get.snackbar('Error', 'Services not available');
      return;
    }
    
    final userId = _globalController!.currentUserId;
    if (userId.isEmpty) {
      Get.snackbar('Error', 'User ID not found');
      return;
    }

    isLoading.value = true;
    
    try {
      final response = await _profileApiService!.updateUserProfile(userId, data);
      
      if (response.isOk) {
        Get.snackbar('Success', 'Profile updated successfully');
        await loadUserProfile();
      } else {
        final errorMessage = response.body['message'] ?? 'Failed to update profile';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}