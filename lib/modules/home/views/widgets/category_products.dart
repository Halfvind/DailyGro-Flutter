import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../../../CommonComponents/CommonWidgets/product_card.dart';
import '../../../product_detail/product_detail_view.dart';
import '../../../products/products_list_view.dart';
import '../../controller/home_controller.dart';
import '../../../product/controllers/product_controller.dart';
import '../../data/all_products_data.dart';

class CategoryProducts extends StatelessWidget {
  const CategoryProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final productController = Get.find<ProductController>();
    
    return Obx(() {
      final categories = homeController.categories;
      if (categories.isEmpty) return const SizedBox.shrink();

      return Column(
        children: categories.map((category) {
          final products = productController.products.where((p) => p.categoryId == category.categoryId).take(2).toList();
          if (products.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: AppSizes.sideHeading,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                   // onTap: () => Get.to(() => ProductsListView(category: category)),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize: AppSizes.sideHeading,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.height(12)),
              SizedBox(
                height: AppSizes.height(280),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: AppSizes.width(190),
                      margin: EdgeInsets.only(right: AppSizes.width(12)),
                      child: GestureDetector(
                        /*  onTap: () => Get.to(() => ProductDetailView(product: products[index],),
                              arguments:{
                                "product": products[index],
                                "categoryId": products[index].categoryId,
                              }),*/
                          child: ProductCard(product: products[index])),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSizes.height(20)),
            ],
          );
        }).toList(),
      );
    });
  }
}