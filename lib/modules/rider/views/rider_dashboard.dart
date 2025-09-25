import 'package:dailygro/modules/rider/views/rider_earnings_screen.dart';
import 'package:dailygro/modules/rider/views/rider_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';
import '../../../CommonComponents/CommonWidgets/logout_button.dart';
import '../controllers/rider_controller.dart';

class RiderDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RiderController());
    
    // Fetch profile data when screen loads
    Future.microtask(() => controller.fetchRiderProfile());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        /*actions: [
          Obx(() => Switch(
            value: controller.isOnline,
            onChanged: (_) => controller.toggleOnlineStatus(),
            activeColor: Colors.green,
          )),
          LogoutButton(),
        ],*/

      ),
      body: Obx(() => controller.isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(controller),
                SizedBox(height: 20),
                _buildStatsSection(controller),
                SizedBox(height: 30),
                _buildQuickActions(),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildStatusCard(RiderController controller) {
    return Obx(() => Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 30),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.riderProfile.value?.riderName ?? 'Rider',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(controller.riderProfile.value?.contactNumber ?? ''),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: controller.isOnline ? Colors.green : Colors.red,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        controller.isOnline ? 'Available' : 'Offline',
                        style: TextStyle(
                          color: controller.isOnline ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(
                  value: controller.isOnline,
                  onChanged: controller.isUpdatingStatus.value 
                    ? null 
                    : (_) => controller.toggleOnlineStatus(),
                  activeColor: Colors.green,
                ),
                Text(
                  controller.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.isOnline ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildStatsSection(RiderController controller) {
    return Obx(() => Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Earnings',
                '\$${controller.riderProfile.value?.totalEarnings ?? 0}',
                Icons.today,
                Colors.green,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Active Orders',
                '${controller.activeOrders.where((o) => o.status != 'delivered').length}',
                Icons.delivery_dining,
                Colors.orange,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Available Orders',
                '${controller.activeOrders.length}',
                Icons.assignment,
                Colors.blue,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Orders',
                '${controller.riderProfile.value?.totalOrders ?? 0}',
                Icons.account_balance_wallet,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'View Orders',
              Icons.list_alt,
              Colors.blue,
              () => Get.toNamed('/rider/orders'),
            ),
            _buildActionCard(
              'Earnings',
              Icons.monetization_on,
              Colors.green,

              () => Get.to(RiderEarningsScreen())
            ),
            _buildActionCard(
              'Profile',
              Icons.person,
              Colors.orange,
              () => Get.to(const RiderProfileScreen())
            ),
            _buildActionCard(
              'Support',
              Icons.help,
              Colors.purple,
              () => Get.snackbar('Support', 'Contact admin at support@dailygro.com'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}