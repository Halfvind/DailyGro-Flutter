import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../CommonComponents/CommonWidgets/logout_button.dart';
import '../../../themes/app_colors.dart';
import '../../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../controllers/rider_controller.dart';

class RiderProfileScreen extends StatefulWidget {
  @override
  _RiderProfileScreenState createState() => _RiderProfileScreenState();
}

class _RiderProfileScreenState extends State<RiderProfileScreen> {
  final RiderController controller = Get.find<RiderController>();
  
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController vehicleTypeController;
  late TextEditingController vehicleNumberController;
  late TextEditingController licenseController;
  late TextEditingController bankAccountController;
  late TextEditingController ifscController;

  @override
  void initState() {
    super.initState();
    final profile = controller.profile;
    nameController = TextEditingController(text: profile.name);
    phoneController = TextEditingController(text: profile.phone);
    emailController = TextEditingController(text: profile.email);
    addressController = TextEditingController(text: profile.address);
    vehicleTypeController = TextEditingController(text: profile.vehicleType);
    vehicleNumberController = TextEditingController(text: profile.vehicleNumber);
    licenseController = TextEditingController(text: profile.licenseNumber);
    bankAccountController = TextEditingController(text: profile.bankAccount);
    ifscController = TextEditingController(text: profile.ifscCode);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
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
        title: Text('Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(controller.profile.profileImage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: () => Get.snackbar('Info', 'Camera functionality not implemented'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Verification Status
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controller.profile.isVerified 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.profile.isVerified ? Icons.verified : Icons.pending,
                    color: controller.profile.isVerified ? Colors.green : Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Text(
                    controller.profile.isVerified ? 'Verified Rider' : 'Verification Pending',
                    style: TextStyle(
                      color: controller.profile.isVerified ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Personal Information
            _buildSectionTitle('Personal Information'),
            CommonTextField(
              controller: nameController,
              labelText: 'Full Name',
              prefixIcon: const Icon(Icons.person,)
            ),
            SizedBox(height: 16),
            CommonTextField(
              controller: phoneController,
              labelText: 'Phone Number',
              prefixIcon:const Icon(Icons.phone,) ,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            CommonTextField(
              controller: emailController,
              labelText: 'Email',
              prefixIcon:const Icon(Icons.email,),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            CommonTextField(
              controller: addressController,
              labelText: 'Address',
              prefixIcon:const Icon(Icons.location_on,),
              maxLines: 2,
            ),
            SizedBox(height: 24),

            // Vehicle Information
            _buildSectionTitle('Vehicle Information'),
            CommonTextField(
              controller: vehicleTypeController,
              labelText: 'Vehicle Type',
              prefixIcon:const Icon(Icons.motorcycle,),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: vehicleNumberController,
              labelText: 'Vehicle Number',
              prefixIcon: const Icon(Icons.confirmation_number,),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: licenseController,
              labelText: 'License Number',
              prefixIcon:  const Icon(Icons.card_membership,)
            ),
            SizedBox(height: 24),

            // Bank Information
            _buildSectionTitle('Bank Information'),
            CommonTextField(
              controller: bankAccountController,
              labelText: 'Bank Account Number',
              prefixIcon: const Icon(Icons.account_balance,) ,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: ifscController,
              labelText: 'IFSC Code',
              prefixIcon: const Icon(Icons.code,) ,
            ),
            const SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: CommonButton(
                text: 'Update Profile',
                onPressed: _updateProfile,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.snackbar('Info', 'Change password functionality not implemented'),
                icon: Icon(Icons.lock),
                label: Text('Change Password'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.snackbar('Support', 'Contact admin at support@dailygro.com'),
                icon: Icon(Icons.help),
                label: Text('Help & Support'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const LogoutButton(),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
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

  void _updateProfile() {
    controller.updateProfile(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      address: addressController.text,
      vehicleType: vehicleTypeController.text,
      vehicleNumber: vehicleNumberController.text,
      licenseNumber: licenseController.text,
      bankAccount: bankAccountController.text,
      ifscCode: ifscController.text,
    );
  }
}