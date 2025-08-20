import 'package:flutter/material.dart';
import '../../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../../../themes/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final quickItems = [
      {
        'title': 'Lights, Diyas\n& Candles',
        'image': '🪔',
        'price': '₹ 79',
        'bgColor': Color(0xFFFFF3E0),
      },
      {
        'title': 'Sweets',
        'image': '🍬',
        'price': '₹ 79',
        'bgColor': Color(0xFFE8F5E8),
      },
      {
        'title': 'Appliances\n& Gadgets',
        'image': '📱',
        'price': '₹ 79',
        'bgColor': Color(0xFFE3F2FD),
      },
      {
        'title': 'Home\nDecoration',
        'image': '🏠',
        'price': '₹ 79',
        'bgColor': Color(0xFFFCE4EC),
      },
    ];

    return Column(
      children: [
        // Quick action items grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.width(12),
            mainAxisSpacing: AppSizes.height(12),
            childAspectRatio: 1.6,
          ),
          itemCount: quickItems.length,
          itemBuilder: (context, index) {
            final item = quickItems[index];
            return Container(
              decoration: BoxDecoration(
                color: item['bgColor'] as Color,
                borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSizes.width(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: TextStyle(
                              fontSize: AppSizes.font(13),
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          item['image'] as String,
                          style: TextStyle(fontSize: AppSizes.font(24)),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(12),
                        vertical: AppSizes.height(6),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                      ),
                      child: Text(
                        item['price'] as String,
                        style: TextStyle(
                          fontSize: AppSizes.font(12),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        AppSizes.vSpace(20),
        // Grocery & Kitchen section
        Container(
          padding: EdgeInsets.all(AppSizes.width(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radius(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.width(60),
                height: AppSizes.height(60),
                decoration: BoxDecoration(
                  color: Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                ),
                child: Center(
                  child: Text(
                    '🥬',
                    style: TextStyle(fontSize: AppSizes.font(28)),
                  ),
                ),
              ),
              AppSizes.hSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grocery & Kitchen',
                      style: TextStyle(
                        fontSize: AppSizes.font(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    AppSizes.vSpace(4),
                    Text(
                      'Fresh vegetables, fruits & daily essentials',
                      style: TextStyle(
                        fontSize: AppSizes.font(12),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: AppSizes.font(16),
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ],
    );
  }
}