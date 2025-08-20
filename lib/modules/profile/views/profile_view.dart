import 'package:dailygro/modules/profile/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../CommonComponents/CommonWidgets/logout_button.dart';
import '../../home/controller/home_controller.dart';
import '../../home/views/widgets/wallet_summary.dart';
import 'personal_info_view.dart';
import 'address_list_view.dart';
import 'help_support_view.dart';
import 'about_view.dart';

class ProfileView extends GetView<HomeController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.width(16)),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(AppSizes.width(20)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppSizes.width(35),
                    backgroundColor: Colors.green,
                    child: Text(
                      controller.userName.value[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: AppSizes.fontXXL,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.width(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                          controller.userName.value,
                          style: TextStyle(
                            fontSize: AppSizes.fontXL,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        SizedBox(height: AppSizes.height(4)),
                        Obx(() => Text(
                          controller.selectedLocation.value,
                          style: TextStyle(
                            fontSize: AppSizes.fontM,
                            color: Colors.grey[600],
                          ),
                        )),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: AppSizes.fontXL,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppSizes.height(20)),
            
            // Wallet Summary
            const WalletSummary(),
            
            SizedBox(height: AppSizes.height(20)),
            
            // Profile Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Update your details',
                    onTap: () => Get.to(() => PersonalInfoView()),
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Address',
                    subtitle: 'Manage your addresses',
                    onTap: () => Get.to(() => AddressListView()),
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Cards, UPI, Wallet',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.favorite,
                    title: 'Your Wishlists',
                    subtitle: 'All Favourites',
                    onTap: () => Get.to(() => WishlistView()),
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage preferences',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'FAQs, Contact us',
                    onTap: () => Get.to(() => HelpSupportView()),
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version, Terms',
                    onTap: () => Get.to(() => AboutView()),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppSizes.height(20)),
            
            // Logout Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const LogoutButton(),
            ),
            
            SizedBox(height: AppSizes.height(20)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(AppSizes.width(8)),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
        ),
        child: Icon(
          icon,
          color: Colors.green,
          size: AppSizes.fontXL,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: AppSizes.fontS,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: AppSizes.fontL,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
  
  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: AppSizes.width(16),
      endIndent: AppSizes.width(16),
    );
  }
}
