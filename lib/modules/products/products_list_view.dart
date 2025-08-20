import 'package:flutter/material.dart';

import '../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../CommonComponents/CommonWidgets/product_card.dart';
import '../../themes/app_colors.dart';
import '../home/data/all_products_data.dart';
import '../home/models/category_model.dart';

class ProductsListView extends StatelessWidget {
  final CategoryModel? category;
  
  const ProductsListView({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final products = category != null 
        ? getProductsByCategory(category!.id!) 
        : getProductsByCategory(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'Products'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SizedBox(
        height: AppSizes.height(290),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
           // crossAxisSpacing: AppSizes.width(12),
            //mainAxisSpacing: AppSizes.height(12),
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        ),
      ),
    );
  }
}