import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../themes/app_colors.dart';
import 'controllers/user_auth_controller.dart';

class UserSignupScreen extends StatelessWidget {
  const UserSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserAuthController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create User Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.person_add, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text(
              'Join DailyGro',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            CommonTextField(
              controller: controller.nameController,
              hintText: 'Full Name',
              prefixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: controller.emailController,
              hintText: 'Email Address',
              prefixIcon: const Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: controller.phoneController,
              hintText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Obx(() => CommonTextField(
              controller: controller.passwordController,
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              obscureText: !controller.isPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            )),
            const SizedBox(height: 16),
            CommonTextField(
              controller: controller.addressController,
              hintText: 'Address (Optional)',
              prefixIcon: const Icon(Icons.location_on),
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            Obx(() => CommonButton(
              text: 'Create Account',
              isLoading: controller.isLoading.value,
              onPressed: controller.register,
            )),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}