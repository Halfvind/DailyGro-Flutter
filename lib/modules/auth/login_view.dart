import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../themes/app_colors.dart';
import 'login_controller.dart';
import 'login_info.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*Lottie.asset(
                'assets/lottie/login.json',
                height: 220,
              ),*/
              const SizedBox(height: 20),
              Text(
                "Welcome Back 👋",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 40),
              CommonTextField(
                controller: controller.emailController,
                hintText: 'Email or Username',
              ),
              const SizedBox(height: 16),
              Obx(() {
                return CommonTextField(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  obscureText: !controller.isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                );
              }),
              const SizedBox(height: 30),
              Obx(() => CommonButton(
                text: 'Login',
                isLoading: controller.isLoading,
                onPressed: controller.onLogin,
              )),
              const SizedBox(height: 20),
              if (controller.selectedRole == 'user') _buildUserSignupOption(),
              if (controller.selectedRole == 'vendor') _buildVendorSignupOption(),
              if (controller.selectedRole == 'rider') _buildRiderSignupOption(),
              const SizedBox(height: 20),
              const LoginInfo(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildUserSignupOption() {
    return Center(
      child: TextButton(
        onPressed: () => Get.toNamed('/user/signup'),
        child: const Text('New user? Create account here'),
      ),
    );
  }
  
  Widget _buildVendorSignupOption() {
    return Center(
      child: TextButton(
        onPressed: () => Get.toNamed('/vendor/signup'),
        child: const Text('New vendor? Create account here'),
      ),
    );
  }
  
  Widget _buildRiderSignupOption() {
    return Center(
      child: TextButton(
        onPressed: () => Get.toNamed('/rider/signup'),
        child: const Text('New rider? Register here'),
      ),
    );
  }
}
