import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vendor_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../../CommonComponents/CommonWidgets/logout_button.dart';
import '../../../themes/app_colors.dart';
import 'vendor_stock_management.dart';
import 'add_product_screen.dart';
import 'vendor_analytics_screen.dart';
import 'vendor_earnings_screen.dart';
import 'vendor_profile_screen.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorController());

    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: const [
          LogoutButton(showText: false),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final vendor = controller.vendor;
        if (vendor == null) {
          return const Center(child: Text('No vendor data'));
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(vendor),
              const SizedBox(height: 16),
              _buildStatsRow(vendor),
              const SizedBox(height: 16),
              _buildQuickActions(),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildWelcomeCard(vendor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${vendor.name}!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(vendor.businessName, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' ${vendor.rating.toStringAsFixed(1)}'),
                const SizedBox(width: 16),
                Icon(Icons.circle, color: vendor.isActive ? Colors.green : Colors.red, size: 12),
                Text(' ${vendor.isActive ? 'Active' : 'Inactive'}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsRow(vendor) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Orders', vendor.totalOrders.toString(), Icons.shopping_bag)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatCard('Earnings', '\$${vendor.totalEarnings.toStringAsFixed(2)}', Icons.attach_money)),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            _buildActionCard('Stock Management', Icons.inventory, () => Get.to(() => const VendorStockManagement())),
            _buildActionCard('Add Product', Icons.add_box, () => Get.to(() => const AddProductScreen())),
            _buildActionCard('Analytics', Icons.analytics, () => Get.to(() => const VendorAnalyticsScreen())),
            _buildActionCard('Earnings', Icons.account_balance_wallet, () => Get.to(() => const VendorEarningsScreen())),
            _buildActionCard('Profile', Icons.person, () => Get.to(() => const VendorProfileScreen())),
            _buildActionCard('Orders', Icons.list_alt, () => Get.toNamed('/vendor/orders')),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}