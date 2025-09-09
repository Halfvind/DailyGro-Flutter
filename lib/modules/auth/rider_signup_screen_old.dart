import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../themes/app_colors.dart';
import '../../CommonComponents/CommonWidgets/common_textfield.dart';

class RiderSignupScreen extends StatefulWidget {
  @override
  _RiderSignupScreenState createState() => _RiderSignupScreenState();
}

class _RiderSignupScreenState extends State<RiderSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final licenseController = TextEditingController();
  final bankAccountController = TextEditingController();
  final ifscController = TextEditingController();

  String selectedVehicleType = 'Motorcycle';
  final vehicleTypes = ['Motorcycle', 'Bicycle', 'Car', 'Scooter'];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    vehicleTypeController.dispose();
    vehicleNumberController.dispose();
    licenseController.dispose();
    bankAccountController.dispose();
    ifscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Registration'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.delivery_dining,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Join as a Rider',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Start earning by delivering orders',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Personal Information
              _buildSectionTitle('Personal Information'),
              CommonTextField(
                controller: nameController,
                labelText: 'Full Name *',
                prefixIcon:Icon(Icons.person) ,
                validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
              ),
              SizedBox(height: 16),
              CommonTextField(
                controller: phoneController,
                labelText: 'Phone Number *',
                prefixIcon: Icon(Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty == true ? 'Phone is required' : null,
              ),
              SizedBox(height: 16),
              CommonTextField(
                controller: emailController,
                labelText: 'Email Address *',
                prefixIcon:Icon(Icons.email) ,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Email is required';
                  if (!GetUtils.isEmail(value!)) return 'Enter valid email';
                  return null;
                },
              ),
              SizedBox(height: 16),
              CommonTextField(
                controller: addressController,
                labelText: 'Address *',
                prefixIcon:Icon(Icons.location_on) ,
                maxLines: 2,
                validator: (value) => value?.isEmpty == true ? 'Address is required' : null,
              ),
              SizedBox(height: 24),

              // Account Security
              _buildSectionTitle('Account Security'),
              CommonTextField(
                controller: passwordController,
                labelText: 'Password *',
                prefixIcon:Icon(Icons.lock) ,
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Password is required';
                  if (value!.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              SizedBox(height: 16),
              CommonTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password *',
                prefixIcon:Icon(Icons.lock_outline) ,
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Confirm password is required';
                  if (value != passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Vehicle Information
              _buildSectionTitle('Vehicle Information'),
              DropdownButtonFormField<String>(
                value: selectedVehicleType,
                decoration: InputDecoration(
                  labelText: 'Vehicle Type *',
                  prefixIcon: Icon(Icons.motorcycle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: vehicleTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) => setState(() => selectedVehicleType = value!),
                validator: (value) => value?.isEmpty == true ? 'Vehicle type is required' : null,
              ),
              SizedBox(height: 16),
              CommonTextField(
                controller: vehicleNumberController,
                labelText: 'Vehicle Number *',
                prefixIcon: const Icon(Icons.confirmation_number),
                validator: (value) => value?.isEmpty == true ? 'Vehicle number is required' : null,
              ),
              SizedBox(height: 16),
              CommonTextField(
                controller: licenseController,
                labelText: 'Driving License Number *',
                prefixIcon: Icon(Icons.card_membership),
                validator: (value) => value?.isEmpty == true ? 'License number is required' : null,
              ),
              SizedBox(height: 24),

              // Bank Information
              _buildSectionTitle('Bank Information'),
              CommonTextField(
                controller: bankAccountController,
                labelText: 'Bank Account Number *',
                prefixIcon:Icon( Icons.account_balance),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? 'Bank account is required' : null,
              ),
              SizedBox(height: 16),
              CommonTextField(
                controller: ifscController,
                labelText: 'IFSC Code *',
                prefixIcon: Icon(Icons.code),
                validator: (value) => value?.isEmpty == true ? 'IFSC code is required' : null,
              ),
              SizedBox(height: 32),

              // Terms and Conditions
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important Information:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Your documents will be verified before activation'),
                    Text('• You must have a valid driving license'),
                    Text('• Vehicle registration is required'),
                    Text('• Bank account will be used for payments'),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: CommonButton(
                  text: 'Register as Rider',
                  onPressed: _submitForm,
                ),
              ),
              const SizedBox(height: 16),

              // Login Link
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Already have an account? Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      Get.snackbar(
        'Registration Submitted',
        'Your rider registration has been submitted for verification. You will be notified once approved.',
        duration: Duration(seconds: 3),
      );
      
      // Navigate back to login
      Get.back();
    }
  }
}