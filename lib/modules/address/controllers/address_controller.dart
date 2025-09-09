import 'package:get/get.dart';
import '../../../CommonComponents/controllers/global_controller.dart';
import '../../../models/address_model.dart';
import '../repositories/address_repository.dart';

class AddressController extends GetxController {
  AddressRepository? _addressRepository;
  GlobalController? _globalController;

  final isLoading = false.obs;
  final addresses = <AddressModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }
  
  @override
  void onReady() {
    super.onReady();
    if (_addressRepository != null && _globalController != null) {
      loadAddresses();
    }
  }

  void _initializeServices() {
    try {
      _addressRepository = Get.find<AddressRepository>();
      _globalController = Get.find<GlobalController>();
    } catch (e) {
      print('Error initializing address services: $e');
      // Retry after a delay
      Future.delayed(Duration(milliseconds: 500), () {
        _initializeServices();
      });
    }
  }

  Future<void> loadAddresses() async {
    if (_globalController == null || _addressRepository == null) {
      print('Address services not initialized yet');
      return;
    }

    final userId = _globalController!.currentUserId;
    if (userId.isEmpty) {
      Get.snackbar('Error', 'User ID not found');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _addressRepository!.getAddresses(userId);

      if (response.isOk) {
        final List<dynamic> addressList = response.body['addresses'] ?? [];
        addresses.value = addressList.map((json) => AddressModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to load addresses');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAddress(Map<String, dynamic> data) async {
    if (_globalController == null || _addressRepository == null) {
      Get.snackbar('Error', 'Services not available');
      return;
    }

    final userId = _globalController!.currentUserId;
    data['user_id'] = userId;

    isLoading.value = true;

    try {
      final response = await _addressRepository!.addAddress(data);

      if (response.isOk) {
        Get.snackbar('Success', 'Address added successfully');
        await loadAddresses();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to add address');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(int addressId, Map<String, dynamic> data) async {
    if (_addressRepository == null) {
      Get.snackbar('Error', 'Service not available');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _addressRepository!.updateAddress(addressId, data);

      if (response.isOk) {
        Get.snackbar('Success', 'Address updated successfully');
        await loadAddresses();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to update address');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(int addressId) async {
    if (_addressRepository == null) {
      Get.snackbar('Error', 'Service not available');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _addressRepository!.deleteAddress(addressId);

      if (response.isOk) {
        Get.snackbar('Success', 'Address deleted successfully');
        await loadAddresses();
      } else {
        Get.snackbar('Error', response.body['message'] ?? 'Failed to delete address');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultAddress(int addressId) async {
    // Get the current address data first
    final address = addresses.firstWhere((addr) => addr.addressId == addressId);
    
    await updateAddress(addressId, {
      'title': address.title,
      'name': address.name,
      'phone': address.phone,
      'address_line': address.addressLine,
      'landmark': address.landmark,
      'city': address.city,
      'state': address.state,
      'pincode': address.pincode,
      'is_default': true,
      'address_type': address.addressType,
    });
  }
}