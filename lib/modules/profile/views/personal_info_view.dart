import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../../themes/app_colors.dart';
import '../../user/repositories/user_repository.dart';
import '../controllers/profile_controller.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController(), permanent: false);
   // final controller = Get.put(UserRepository());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.userProfile.value;
        if (user == null) {
          return const Center(child: Text('No profile data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.person, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Profile Information',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              _buildInfoCard('Name', user.name),
              const SizedBox(height: 16),
              
              _buildInfoCard('Email', user.email),
              const SizedBox(height: 16),
              
              _buildInfoCard('Phone', user.phone),
              const SizedBox(height: 16),
              
              _buildInfoCard('Role', user.role.toUpperCase()),
              const SizedBox(height: 16),
              
              if (user.address != null)
                _buildInfoCard('Address', user.address!),
              const SizedBox(height: 16),
              
              if (user.createdAt != null)
                _buildInfoCard('Member Since', 
                  '${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}'),
              
              const SizedBox(height: 32),
              
              CommonButton(
                text: 'Edit Profile',
                onPressed: () => _showEditDialog(context, controller, user),
              ),
              
              const SizedBox(height: 16),
              
              CommonButton(
                text: 'Refresh Profile',
                onPressed: controller.loadUserProfile,
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

  void _showEditDialog(BuildContext context, ProfileController controller, user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final addressController = TextEditingController(text: user.address ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
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
                'role':user.role
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