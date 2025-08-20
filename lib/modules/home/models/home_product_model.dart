import 'package:get/get.dart';

class ProductVariant {
  final String unit;
  final double price;
  final double originalPrice;
  final double discount;
  
  ProductVariant({
    required this.unit, 
    required this.price,
    this.originalPrice = 0.0,
    this.discount = 0.0,
  });
}

class HomeProductModel {
  final int id;
  final String name;
  final String imageUrl;
  final String? image;
  final String category;
  final String description;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final bool? isFeatured;
  final bool? isRecommended;
  final bool? isBestSeller;
  final int? categoryId;
  final List<ProductVariant> variants;

  RxInt selectedVariantIndex = 0.obs;

  HomeProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.image,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    this.isFeatured,
    this.isRecommended,
    this.isBestSeller,
    this.categoryId,
    this.variants = const [],
  });

  // Get current selected variant
  ProductVariant get selectedVariant => 
      variants.isNotEmpty ? variants[selectedVariantIndex.value] : 
      ProductVariant(unit: '1 kg', price: 0.0);

  // Get current price
  double get currentPrice => selectedVariant.price;

  // Get current unit
  String get currentUnit => selectedVariant.unit;

  // Change variant
  void selectVariant(int index) {
    if (index >= 0 && index < variants.length) {
      selectedVariantIndex.value = index;
    }
  }
}
