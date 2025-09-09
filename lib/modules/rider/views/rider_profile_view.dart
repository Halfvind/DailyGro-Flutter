import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../../themes/app_colors.dart';
import '../controllers/rider_profile_controller.dart';

class RiderProfileView extends StatelessWidget {
  const RiderProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RiderProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rider Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final rider = controller.riderProfile.value;
        if (rider == null) {
          return const Center(child: Text('No profile data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.delivery_dining, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Rider Profile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              _buildInfoCard('Name', rider.name),
              const SizedBox(height: 16),
              
              _buildInfoCard('Email', rider.email),
              const SizedBox(height: 16),
              
              _buildInfoCard('Phone', rider.phone),
              const SizedBox(height: 16),
              
              _buildInfoCard('Role', rider.role.toUpperCase()),
              const SizedBox(height: 16),
              
              if (rider.address != null)
                _buildInfoCard('Address', rider.address!),
              
              const SizedBox(height: 32),
              
              CommonButton(
                text: 'Edit Profile',
                onPressed: () => _showEditDialog(context, controller, rider),
              ),
              
              const SizedBox(height: 16),
              
              CommonButton(
                text: 'Refresh Profile',
                onPressed: controller.loadRiderProfile,
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

  void _showEditDialog(BuildContext context, RiderProfileController controller, rider) {
    final nameController = TextEditingController(text: rider.name);
    final phoneController = TextEditingController(text: rider.phone);
    final addressController = TextEditingController(text: rider.address ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Rider Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextField(
              controller: nameController,
              hintText: 'Name',
              prefixIcon: const Icon(Icons.person),
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
              hintText: 'Address',
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
              controller.updateProfile({
                'name': nameController.text,
                'phone': phoneController.text,
                'address': addressController.text,
                'vehicle_type': 'bike', // Add vehicle specific fields
                'license_number': 'DL123456',
              });
              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}