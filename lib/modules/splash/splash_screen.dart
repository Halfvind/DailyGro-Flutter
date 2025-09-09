import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CommonComponents/controllers/global_controller.dart';
import '../../themes/app_colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final globalController=GlobalController();
  @override
  void initState() {
    super.initState();
    _navigateToRoleSelector();
  }

  Future<void> _navigateToRoleSelector() async {
    await Future.delayed(const Duration(seconds: 3));
    globalController.checkAutoLogin();
  // Get.offAllNamed('/role-selector');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'DailyGro',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Fresh Groceries Delivered',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}