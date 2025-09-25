import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../../CommonComponents/CommonWidgets/logout_button.dart';
import '../../../themes/app_colors.dart';
import '../controllers/vendor_controller.dart';


class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _shopNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _upiController = TextEditingController();
  late final VendorController _vendorController;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }
  
  void _initializeController() {
    try {
      _vendorController = Get.find<VendorController>();
    } catch (e) {
      _vendorController = Get.put(VendorController());
    }
    _loadVendorProfile();
  }

  void _loadVendorProfile() async {
    await _vendorController.loadVendorProfile();
    _updateTextFields();
  }

  void _updateTextFields() {
    final vendor = _vendorController.vendor;
    if (vendor != null && mounted) {
      _shopNameController.text = vendor.businessName;
      _ownerNameController.text = vendor.name;
      _phoneController.text = vendor.phone;
      _emailController.text = vendor.email;
      _addressController.text = vendor.address;
      _licenseController.text = _vendorController.businessLicense;
      _upiController.text = _vendorController.upiId;
      _bankAccountController.text = _vendorController.bankAccount;
    }
  }

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
            Obx(() => Text(
              _vendorController.vendor?.businessName ?? 'Loading...',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            Obx(() => Text(
              'Vendor ID: ${_vendorController.vendor?.id ?? 'Loading...'}',
              style: TextStyle(color: Colors.grey[600]),
            )),
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
    return Obx(() => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Business Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Store Status', style: TextStyle(fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _vendorController.storeStatus == 'open'
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _vendorController.storeStatus == 'open'
                          ? Colors.green
                          : Colors.red,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _vendorController.storeStatus == 'open' ? 'Open' : 'Closed',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _vendorController.storeStatus == 'open'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: _vendorController.storeStatus == 'open',
                        onChanged: (value) {
                          _vendorController.updateStoreStatus(value);
                        },
                        activeColor: AppColors.primary,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: Colors.red.shade200,
                        activeTrackColor: AppColors.primary.withOpacity(0.4),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Operating Hours', style: TextStyle(fontWeight: FontWeight.w500)),
                TextButton(
                  onPressed: _pickOperatingHours,
                  child: Text(
                    '${_vendorController.openingTime.substring(0, 5)} - ${_vendorController.closingTime.substring(0, 5)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> _pickOperatingHours() async {
    TimeOfDay? opening = await showTimePicker(
      context: context,
      initialTime: _stringToTimeOfDay(_vendorController.openingTime),
    );

    if (opening == null) return;

    TimeOfDay? closing = await showTimePicker(
      context: context,
      initialTime: _stringToTimeOfDay(_vendorController.closingTime),
    );

    if (closing == null) return;

    _vendorController.updateOperatingHours(
      _timeOfDayToString(opening),
      _timeOfDayToString(closing),
    );
  }

  TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
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
    final profileData = {
      'vendor_id': _vendorController.vendor?.id.toString() ?? '1',
      'store_name': _shopNameController.text,
      'business_license': _licenseController.text,
      'business_address': _addressController.text,
      'business_type': _vendorController.businessType,
      'verification_status': 'verified',
      'rating': _vendorController.vendor?.rating ?? 0.0,
      'store_status': _vendorController.storeStatus=='closed'?0:1,
      'opening_time': _vendorController.openingTime,
      'closing_time': _vendorController.closingTime,
      'upi_id': _upiController.text,
      'bank_account_number': _bankAccountController.text,
      'vendor_name':_ownerNameController.text,
      'vendor_mail':_emailController.text,
      'contact_number':_phoneController.text
    };
    print(profileData);

    final success = await _vendorController.updateVendorProfile(profileData);

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
