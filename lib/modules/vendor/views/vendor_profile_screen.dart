import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../../CommonComponents/CommonWidgets/logout_button.dart';
import '../../../themes/app_colors.dart';
import '../controllers/vendor_controller.dart';
import '../models/vendor_model.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _shopNameController = TextEditingController(text: 'Fresh Mart Store');
  final _ownerNameController = TextEditingController(text: 'John Doe');
  final _phoneController = TextEditingController(text: '+1 234 567 8900');
  final _emailController = TextEditingController(text: 'vendor@dailygro.com');
  final _addressController = TextEditingController(text: '123 Market Street, City');
  final _licenseController = TextEditingController(text: 'BL123456789');
  final _bankAccountController = TextEditingController(text: '****1234');
  final _upiController = TextEditingController(text: 'vendor@upi');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildBusinessInfo(),
            const SizedBox(height: 24),
            _buildContactInfo(),
            const SizedBox(height: 24),
            _buildBusinessSettings(),
            const SizedBox(height: 24),
            _buildPaymentInfo(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.store, size: 50, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeProfileImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _shopNameController.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Vendor ID: VEN001',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const Text(' 4.8 (324 reviews)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfo() {
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
              hintText: 'Shop Name',
              prefixIcon: const Icon(Icons.store),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _ownerNameController,
              hintText: 'Owner Name',
              prefixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _licenseController,
              hintText: 'Business License Number',
              prefixIcon: const Icon(Icons.badge),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _phoneController,
              hintText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _emailController,
              hintText: 'Email Address',
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _addressController,
              hintText: 'Business Address',
              prefixIcon: const Icon(Icons.location_on),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Business Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSettingItem('Store Status', 'Open', Icons.store, true),
            _buildSettingItem('Delivery Radius', '5 km', Icons.location_on, false),
            _buildSettingItem('Minimum Order', '\$20', Icons.shopping_cart, false),
            _buildSettingItem('Operating Hours', '9 AM - 9 PM', Icons.access_time, false),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String value, IconData icon, bool hasSwitch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          if (hasSwitch)
            Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            )
          else
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _bankAccountController,
              hintText: 'Bank Account Number',
              prefixIcon: const Icon(Icons.account_balance),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _upiController,
              hintText: 'UPI ID',
              prefixIcon: const Icon(Icons.payment),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Payment details verified', style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CommonButton(
          text: 'Save Changes',
          onPressed: _saveProfile,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const LogoutButton(),
        ),
      ],
    );
  }

  void _changeProfileImage() {
    Get.snackbar('Info', 'Image picker functionality to be implemented');
  }

  void _saveProfile() async {
    final controller = Get.find<VendorController>();
    
    final updatedVendor = VendorModel(
      id: controller.vendor?.id ?? '1',
      name: _ownerNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      businessName: _shopNameController.text,
      address: _addressController.text,
      isActive: controller.vendor?.isActive ?? true,
      rating: controller.vendor?.rating ?? 4.8,
      totalOrders: controller.vendor?.totalOrders ?? 0,
      totalEarnings: controller.vendor?.totalEarnings ?? 0.0,
    );
    
    final success = await controller.updateVendorProfile(updatedVendor);
    
    if (success) {
      Get.snackbar('Success', 'Profile updated successfully');
    } else {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }



  @override
  void dispose() {
    _shopNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    _bankAccountController.dispose();
    _upiController.dispose();
    super.dispose();
  }
}