import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.width(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Options
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
                    'Need Help?',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(8)),
                  Text(
                    'We\'re here to help you 24/7',
                    style: TextStyle(
                      fontSize: AppSizes.fontM,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppSizes.height(20)),
            
            // Contact Methods
            _buildContactOption(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '+91 1800-123-4567',
              onTap: () => Get.snackbar('Call', 'Calling customer support...'),
            ),
            
            _buildContactOption(
              icon: Icons.email,
              title: 'Email Us',
              subtitle: 'support@dailygro.com',
              onTap: () => Get.snackbar('Email', 'Opening email client...'),
            ),
            
            _buildContactOption(
              icon: Icons.chat,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              onTap: () => Get.snackbar('Chat', 'Starting live chat...'),
            ),
            
            SizedBox(height: AppSizes.height(20)),
            
            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: AppSizes.fontL,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: AppSizes.height(12)),
            
            _buildFAQItem(
              question: 'How do I track my order?',
              answer: 'You can track your order in the Orders section of the app. You\'ll receive real-time updates on your order status.',
            ),
            
            _buildFAQItem(
              question: 'What is your return policy?',
              answer: 'We offer a 7-day return policy for fresh products and 30-day return policy for packaged goods.',
            ),
            
            _buildFAQItem(
              question: 'How do I apply coupons?',
              answer: 'You can apply coupons during checkout. Available coupons will be shown based on your order value.',
            ),
            
            _buildFAQItem(
              question: 'What are the delivery charges?',
              answer: 'Delivery is free for orders above ₹299. For orders below ₹299, a delivery charge of ₹49 applies.',
            ),
            
            _buildFAQItem(
              question: 'How do I change my delivery address?',
              answer: 'You can manage your delivery addresses in the Profile section under Delivery Address.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(AppSizes.width(12)),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radius(8)),
          ),
          child: Icon(
            icon,
            color: Colors.green,
            size: AppSizes.fontXXL,
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
            fontSize: AppSizes.fontM,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppSizes.fontL,
          color: Colors.grey[400],
        ),
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
          side: BorderSide(color: Colors.grey[200]!),
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height(8)),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: AppSizes.fontM,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(AppSizes.width(16)),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: AppSizes.fontM,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
          side: BorderSide(color: Colors.grey[200]!),
        ),
      ),
    );
  }
}