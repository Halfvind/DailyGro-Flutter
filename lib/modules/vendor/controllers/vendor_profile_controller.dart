import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../models/user_model.dart';
import '../repositories/vendor_repository.dart';

class VendorProfileController extends GetxController {
  final VendorRepository _repository = Get.find<VendorRepository>();
  final GlobalController _globalController = Get.find<GlobalController>();
  
  final isLoading = false.obs;
  final vendorProfile = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadVendorProfile();
  }

  Future<void> loadVendorProfile() async {
    final userId = _globalController.currentUserId;
    if (userId.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await _repository.getVendorProfile(userId);
      if (response.isOk) {
        vendorProfile.value = UserModel.fromProfileResponse(response.body);
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
      final response = await _repository.updateVendorProfile(userId, data);
      if (response.isOk) {
        Get.snackbar('Success', 'Profile updated successfully');
        await loadVendorProfile();
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