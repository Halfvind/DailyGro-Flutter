import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../themes/app_colors.dart';

class VendorSignupScreen extends StatefulWidget {
  const VendorSignupScreen({super.key});

  @override
  State<VendorSignupScreen> createState() => _VendorSignupScreenState();
}

class _VendorSignupScreenState extends State<VendorSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Registration'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Your Vendor Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Join DailyGro as a vendor and start selling your products',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _buildBusinessSection(),
              const SizedBox(height: 20),
              _buildPersonalSection(),
              const SizedBox(height: 20),
              _buildAccountSection(),
              const SizedBox(height: 32),
              _buildSignupButton(),
              const SizedBox(height: 16),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Business Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _shopNameController,
              hintText: 'Shop/Business Name',
              prefixIcon: const Icon(Icons.store),
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _addressController,
              hintText: 'Business Address',
              prefixIcon: const Icon(Icons.location_on),
              maxLines: 2,
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _licenseController,
              hintText: 'Business License Number (Optional)',
              prefixIcon: const Icon(Icons.badge),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _ownerNameController,
              hintText: 'Owner/Manager Name',
              prefixIcon: const Icon(Icons.person),
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _phoneController,
              hintText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _emailController,
              hintText: 'Email Address',
              prefixIcon: const Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty == true) return 'Required';
                if (!GetUtils.isEmail(value!)) return 'Invalid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              validator: (value) {
                if (value?.isEmpty == true) return 'Required';
                if (value!.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return CommonButton(
      text: 'Create Vendor Account',
      isLoading: _isLoading,
      onPressed: _signup,
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Already have an account? Login here'),
      ),
    );
  }

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    Get.snackbar('Success', 'Vendor account created successfully!');
    Get.offAllNamed('/vendor/dashboard');
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    super.dispose();
  }
}