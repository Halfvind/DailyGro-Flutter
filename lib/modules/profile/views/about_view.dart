import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.width(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: AppSizes.width(100),
                    height: AppSizes.height(100),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                    ),
                    child: Icon(
                      Icons.shopping_basket,
                      size: AppSizes.font(50),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(16)),
                  Text(
                    'DailyGro',
                    style: TextStyle(
                      fontSize: AppSizes.fontXXXL,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppSizes.height(32)),
            
            // About Section
            _buildSection(
              title: 'About DailyGro',
              content: 'DailyGro is your trusted partner for fresh groceries and daily essentials. We deliver quality products right to your doorstep with the convenience of online shopping and the assurance of freshness.',
            ),
            
            _buildSection(
              title: 'Our Mission',
              content: 'To make grocery shopping convenient, affordable, and accessible for everyone while supporting local farmers and suppliers.',
            ),
            
            _buildSection(
              title: 'Features',
              content: '• Fresh fruits and vegetables\n• Wide range of products\n• Quick delivery\n• Secure payments\n• Easy returns\n• 24/7 customer support',
            ),
            
            SizedBox(height: AppSizes.height(20)),
            
            // Legal Links
            Container(
              padding: EdgeInsets.all(AppSizes.width(16)),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Legal',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(12)),
                  _buildLegalLink('Terms of Service', () {
                    Get.snackbar('Terms', 'Opening Terms of Service...');
                  }),
                  _buildLegalLink('Privacy Policy', () {
                    Get.snackbar('Privacy', 'Opening Privacy Policy...');
                  }),
                  _buildLegalLink('Refund Policy', () {
                    Get.snackbar('Refund', 'Opening Refund Policy...');
                  }),
                ],
              ),
            ),
            
            SizedBox(height: AppSizes.height(20)),
            
            // Contact Info
            Container(
              padding: EdgeInsets.all(AppSizes.width(16)),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(12)),
                  _buildContactInfo(Icons.email, 'support@dailygro.com'),
                  _buildContactInfo(Icons.phone, '+91 1800-123-4567'),
                  _buildContactInfo(Icons.location_on, 'Visakhapatnam, Andhra Pradesh'),
                ],
              ),
            ),
            
            SizedBox(height: AppSizes.height(20)),
            
            // Copyright
            Center(
              child: Text(
                '© 2024 DailyGro. All rights reserved.',
                style: TextStyle(
                  fontSize: AppSizes.fontS,
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            SizedBox(height: AppSizes.height(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppSizes.fontL,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.height(8)),
          Text(
            content,
            style: TextStyle(
              fontSize: AppSizes.fontM,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalLink(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.height(8)),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: AppSizes.fontM,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: AppSizes.fontS,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.height(4)),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.fontL,
            color: Colors.green,
          ),
          SizedBox(width: AppSizes.width(8)),
          Text(
            text,
            style: TextStyle(
              fontSize: AppSizes.fontM,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}