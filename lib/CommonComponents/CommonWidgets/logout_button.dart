import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/global_controller.dart';

class LogoutButton extends StatelessWidget {
  final bool showText;
  final Color? iconColor;
  
  const LogoutButton({
    super.key,
    this.showText = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final globalController = Get.find<GlobalController>();
    
    return showText 
      ? ListTile(
          leading: Icon(Icons.logout, color: iconColor ?? Colors.red),
          title: const Text('Logout'),
          onTap: () => _showLogoutDialog(globalController),
        )
      : IconButton(
          icon: Icon(Icons.logout, color: iconColor ?? Colors.white),
          onPressed: () => _showLogoutDialog(globalController),
        );
  }

  void _showLogoutDialog(GlobalController globalController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              globalController.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}