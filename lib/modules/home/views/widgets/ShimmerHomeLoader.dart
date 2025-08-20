import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../CommonComponents/CommonUtils/app_sizes.dart';

class ShimmerHomeLoader extends StatelessWidget {
  const ShimmerHomeLoader({super.key});

  Widget _buildShimmerContainer({double height = 100, double width = double.infinity, BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p16),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerContainer(height: 24, width: 160), // Greeting
            AppSizes.vSpace(8),
            _buildShimmerContainer(height: 48, radius: BorderRadius.circular(8)), // Search bar
            AppSizes.vSpace(16),
            _buildShimmerContainer(height: 100, radius: BorderRadius.circular(16)), // Wallet summary
            AppSizes.vSpace(20),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (_, __) => AppSizes.hSpace(12),
                itemBuilder: (_, __) => _buildShimmerContainer(height: 100, width: 80),
              ),
            ), // Category list
            AppSizes.vSpace(20),
            _buildShimmerContainer(height: 24, width: 120), // Featured Title
            AppSizes.vSpace(12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => AppSizes.hSpace(12),
                itemBuilder: (_, __) => _buildShimmerContainer(height: 180, width: 140),
              ),
            ), // Featured Products
            AppSizes.vSpace(20),
            _buildShimmerContainer(height: 24, width: 160), // Recommended Title
            AppSizes.vSpace(12),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              separatorBuilder: (_, __) => AppSizes.vSpace(16),
              itemBuilder: (_, __) => _buildShimmerContainer(height: 100),
            ), // Recommended Products
          ],
        ),
      ),
    );
  }
}
