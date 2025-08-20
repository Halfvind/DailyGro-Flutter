import 'package:get/get.dart';
import '../models/address_model.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyAddresses();
  }

  void loadDummyAddresses() {
    addresses.assignAll([
      AddressModel(
        id: '1',
        title: 'Home',
        fullName: 'Aravind',
        phone: '+91 9876543210',
        addressLine1: '123 Main Street',
        addressLine2: 'Near Park',
        city: 'Visakhapatnam',
        state: 'Andhra Pradesh',
        pincode: '530001',
        isDefault: true,
      ),
    ]);
  }

  void addAddress(AddressModel address) {
    if (address.isDefault) {
      for (var addr in addresses) {
        addr.isDefault = false;
      }
    }
    addresses.add(address);
  }

  void updateAddress(int index, AddressModel updatedAddress) {
    if (updatedAddress.isDefault) {
      for (var addr in addresses) {
        addr.isDefault = false;
      }
    }
    addresses[index] = updatedAddress;
  }

  void deleteAddress(int index) {
    addresses.removeAt(index);
  }

  void setDefaultAddress(int index) {
    for (var addr in addresses) {
      addr.isDefault = false;
    }
    addresses[index].isDefault = true;
    addresses.refresh();
  }
}