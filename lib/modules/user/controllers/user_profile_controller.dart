import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserProfileController extends GetxController {
  final UserRepository _repository = Get.find<UserRepository>();
  final GlobalController _globalController = Get.find<GlobalController>();
  
  final isLoading = false.obs;
  final userProfile = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final userId = _globalController.currentUserId;
    if (userId.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await _repository.getUserProfile(userId);
      if (response.isOk) {
        userProfile.value = UserModel.fromProfileResponse(response.body);
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final userId = _globalController.currentUserId;
    if (userId.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await _repository.updateUserProfile(userId, data);
      if (response.isOk) {
        Get.snackbar('Success', 'Profile updated successfully');
        await loadUserProfile();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Update failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}