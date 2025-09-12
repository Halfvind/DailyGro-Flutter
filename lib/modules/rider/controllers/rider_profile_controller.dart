import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../models/user_model.dart';
import '../repositories/rider_repository.dart';

class RiderProfileController extends GetxController {
  final RiderRepository _repository = Get.find<RiderRepository>();
  final GlobalController _globalController = Get.find<GlobalController>();
  
  final isLoading = false.obs;
  final riderProfile = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadRiderProfile();
  }

  Future<void> loadRiderProfile() async {
    int userIdInt = _globalController!.userId.value;
    if (userIdInt.isEqual(0)) return;

    isLoading.value = true;
    try {
      final response = await _repository.getRiderProfile(userIdInt.toString());
      if (response.isOk) {
        riderProfile.value = UserModel.fromProfileResponse(response.body);
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
    int userIdInt = _globalController!.userId.value;
    if (userIdInt.isEqual(0)) return;

    isLoading.value = true;
    try {
      final response = await _repository.updateRiderProfile(userIdInt.toString(), data);
      if (response.isOk) {
        Get.snackbar('Success', 'Profile updated successfully');
        await loadRiderProfile();
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