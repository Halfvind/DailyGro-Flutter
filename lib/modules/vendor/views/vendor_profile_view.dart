/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../../themes/app_colors.dart';
import '../controllers/vendor_profile_controller.dart';

class VendorProfileView extends StatelessWidget {
  const VendorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vendor Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final vendor = controller.vendorProfile.value;
        if (vendor == null) {
          return const Center(child: Text('No profile data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.store, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Vendor Profile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              _buildInfoCard('Business Name', vendor.name),
              const SizedBox(height: 16),
              
              _buildInfoCard('Email', vendor.email),
              const SizedBox(height: 16),
              
              _buildInfoCard('Phone', vendor.phone),
              const SizedBox(height: 16),
              
              _buildInfoCard('Role', vendor.role.toUpperCase()),
              const SizedBox(height: 16),
              
              if (vendor.address != null)
                _buildInfoCard('Business Address', vendor.address!),
              
              const SizedBox(height: 32),
              
              CommonButton(
                text: 'Edit Profile',
                onPressed: () => _showEditDialog(context, controller, vendor),
              ),
              
              const SizedBox(height: 16),
              
              CommonButton(
                text: 'Refresh Profile',
                onPressed: (){},
                //controller.loadVendorProfile,
                backgroundColor: Colors.grey[600],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, VendorProfileController controller, vendor) {
    final nameController = TextEditingController(text: vendor.name);
    final phoneController = TextEditingController(text: vendor.phone);
    final addressController = TextEditingController(text: vendor.address ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Vendor Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextField(
              controller: nameController,
              hintText: 'Business Name',
              prefixIcon: const Icon(Icons.store),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: phoneController,
              hintText: 'Phone',
              prefixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: addressController,
              hintText: 'Business Address',
              prefixIcon: const Icon(Icons.location_on),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
           */
/*   controller.updateProfile({
                'business_name': nameController.text,
                'phone': phoneController.text,
                'business_address': addressController.text,
              });*//*

              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}*/
