import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../models/address_model.dart';
import '../../address/controllers/address_controller.dart';

class AddAddressView extends GetView<AddressController> {
  final AddressModel? address;
  final int? index;

  const AddAddressView({super.key, this.address, this.index});

  @override
  Widget build(BuildContext context) {
    final isEditing = address != null;
    
    final titleController = TextEditingController(text: address?.title ?? '');
    final nameController = TextEditingController(text: address?.name ?? '');
    final phoneController = TextEditingController(text: address?.phone ?? '');
    final address1Controller = TextEditingController(text: address?.addressLine ?? '');
    final address2Controller = TextEditingController(text: address?.city ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final stateController = TextEditingController(text: address?.state ?? '');
    final pincodeController = TextEditingController(text: address?.pincode ?? '');
    final isDefaultController = RxBool(address?.isDefault ?? false);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Address' : 'Add Address'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.width(16)),
        child: Column(
          children: [
            _buildTextField(
              controller: titleController,
              label: 'Address Title (Home, Office, etc.)',
              icon: Icons.label_outline,
            ),
            SizedBox(height: AppSizes.height(16)),
            _buildTextField(
              controller: nameController,
              label: 'Full Name',
              icon: Icons.person_outline,
            ),
            SizedBox(height: AppSizes.height(16)),
            _buildTextField(
              controller: phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: AppSizes.height(16)),
            _buildTextField(
              controller: address1Controller,
              label: 'Address Line 1',
              icon: Icons.location_on_outlined,
            ),
            SizedBox(height: AppSizes.height(16)),
            _buildTextField(
              controller: address2Controller,
              label: 'Address Line 2 (Optional)',
              icon: Icons.location_on_outlined,
            ),
            SizedBox(height: AppSizes.height(16)),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: cityController,
                    label: 'City',
                    icon: Icons.location_city_outlined,
                  ),
                ),
                SizedBox(width: AppSizes.width(12)),
                Expanded(
                  child: _buildTextField(
                    controller: stateController,
                    label: 'State',
                    icon: Icons.map_outlined,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.height(16)),
            _buildTextField(
              controller: pincodeController,
              label: 'Pincode',
              icon: Icons.pin_drop_outlined,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSizes.height(16)),
            
            // Default Address Checkbox
            Obx(() => CheckboxListTile(
              title: const Text('Set as default address'),
              value: isDefaultController.value,
              onChanged: (value) => isDefaultController.value = value!,
              activeColor: Colors.green,
              controlAffinity: ListTileControlAffinity.leading,
            )),
            
            SizedBox(height: AppSizes.height(32)),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateFields([
                    titleController,
                    nameController,
                    phoneController,
                    address1Controller,
                    cityController,
                    stateController,
                    pincodeController,
                  ])) {
                    final newAddress = AddressModel(
                      title: titleController.text,
                      phone: phoneController.text,
                      city: cityController.text,
                      state: stateController.text,
                      pincode: pincodeController.text,
                      isDefault: true,
                      addressId: 1, userId: 1, name: '', addressLine: '',
                      addressType: '', createdAt: '',
                    );

                    if (isEditing && index != null) {
                      //controller.updateAddress(index!, newAddress);
                    } else {
                      //controller.addAddress(newAddress);
                    }

                    Get.back();
                    Get.snackbar(
                      'Success',
                      isEditing ? 'Address updated successfully' : 'Address added successfully',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                  ),
                ),
                child: Text(
                  isEditing ? 'Update Address' : 'Save Address',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  bool _validateFields(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill all required fields',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }
    return true;
  }
}