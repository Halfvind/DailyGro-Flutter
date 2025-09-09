import 'package:flutter/material.dart';
import '../../../CommonComponents/CommonWidgets/product_card.dart';
import '../../../modules/home/models/home_product_model.dart';

class CommonProductCard extends StatelessWidget {
  final HomeProductModel product;

  const CommonProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox() ;
    //  return ProductCard(product: product);
  }
}
