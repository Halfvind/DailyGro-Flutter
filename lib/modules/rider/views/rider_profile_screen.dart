import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonWidgets/logout_button.dart';
import '../../../themes/app_colors.dart';
import '../controllers/rider_controller.dart';

class RiderProfileScreen extends StatefulWidget {

  const RiderProfileScreen({super.key});

  @override
  State<RiderProfileScreen> createState() => _RiderProfileScreenState();
}

class _RiderProfileScreenState extends State<RiderProfileScreen> {
  final RiderController controller = Get.find<RiderController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => controller.fetchRiderProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => controller.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            onPressed: () => Get.snackbar('Info', 'Camera functionality not implemented'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Verification Status
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: controller.riderProfile.value?.verificationStatus == 'verified'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.riderProfile.value?.verificationStatus == 'verified'
                            ? Icons.verified : Icons.pending,
                        color: controller.riderProfile.value?.verificationStatus == 'verified'
                            ? Colors.green : Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        controller.riderProfile.value?.verificationStatus == 'verified'
                            ? 'Verified Rider' : 'Verification Pending',
                        style: TextStyle(
                          color: controller.riderProfile.value?.verificationStatus == 'verified'
                              ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Profile Information Cards
                _buildInfoCard('Personal Information', [
                  _buildInfoRow('Name', controller.riderProfile.value?.riderName ?? ''),
                  _buildInfoRow('Email', controller.riderProfile.value?.riderEmail ?? ''),
                  _buildInfoRow('Phone', controller.riderProfile.value?.contactNumber ?? ''),
                ]),

                SizedBox(height: 16),

                _buildInfoCard('Vehicle Information', [
                  _buildInfoRow('Vehicle Type', controller.riderProfile.value?.vehicleType ?? ''),
                  _buildInfoRow('Vehicle Number', controller.riderProfile.value?.vehicleNumber ?? 'Not provided'),
                  _buildInfoRow('License Number', controller.riderProfile.value?.licenseNumber ?? ''),
                ]),

      /*          SizedBox(height: 16),

                _buildInfoCard('Statistics', [
                  _buildInfoRow('Total Earnings', '\$${controller.riderProfile.value?.totalEarnings ?? 0}'),
                  _buildInfoRow('Total Orders', '${controller.riderProfile.value?.totalOrders ?? 0}'),
                  _buildInfoRow('Total Deliveries', '${controller.riderProfile.value?.totalDeliveries ?? 0}'),
                  _buildInfoRow('Rating', '${controller.riderProfile.value?.rating ?? 0} ⭐'),
                ]),*/

                SizedBox(height: 32),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.snackbar('Info', 'Edit profile functionality not implemented'),
                    icon: Icon(Icons.edit),
                    label: Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
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
          ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}