import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../../themes/app_colors.dart';
import '../../controller/home_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Row with delivery info and profile
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver in',
                  style: TextStyle(
                    fontSize: AppSizes.font(12),
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                AppSizes.vSpace(2),
                Row(
                  children: [
                    Text(
                      '16 minutes',
                      style: TextStyle(
                        fontSize: AppSizes.font(16),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    AppSizes.hSpace(4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: AppSizes.font(16),
                      color: AppColors.primaryText,
                    ),
                  ],
                ),
                AppSizes.vSpace(2),
                Row(
                  children: [
                    Text(
                      'HOME',
                      style: TextStyle(
                        fontSize: AppSizes.font(11),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    AppSizes.hSpace(4),
                    Text(
                      '- Rajat Gowda, Basavanagudi, Jayanagar (560)',
                      style: TextStyle(
                        fontSize: AppSizes.font(11),
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: AppSizes.width(40),
              height: AppSizes.height(40),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: AppSizes.font(20),
              ),
            ),
          ],
        ),
        AppSizes.vSpace(16),
        // Search Bar
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(16),
            vertical: AppSizes.height(12),
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(AppSizes.radius(12)),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.grey[600],
                size: AppSizes.font(20),
              ),
              AppSizes.hSpace(12),
              Expanded(
                child: Text(
                  'Search for groceries',
                  style: TextStyle(
                    fontSize: AppSizes.font(14),
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Icon(
                Icons.mic,
                color: AppColors.primary,
                size: AppSizes.font(20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
