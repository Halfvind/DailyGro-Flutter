import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'product_model.dart';

class CartModel {
  final int cartId;
  final int productId;
  final String name;
  final double price;
  final int quantity;
  final String? image;
  final String unit;
  final String weight;
  final double itemTotal;

  // Computed properties for compatibility
  ProductModel get product => ProductModel(
    productId: productId,
    vendorId: 0,
    categoryId: 0,
    name: name,
    description: '',
    price: price,
    originalPrice: price,
    stockQuantity: 0,
    unit: unit,
    weight: weight,
    image: image,
    isFeatured: false,
    isRecommended: false,
    rating: 0,
    avgRating: 0,
    reviewCount: 0,
    categoryName: '',
    vendorName: '',
    vendorOwnerName: '',
    vendorRating: 0,
    discountPercentage: 0,
    createdAt: DateTime.now(),
  );
  
  RxInt get selectedVariantIndex => 0.obs;
  double get totalPrice => itemTotal;

  CartModel({
    required this.cartId,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
    required this.unit,
    required this.weight,
    required this.itemTotal,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cart_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      image: json['image'],
      unit: json['unit'] ?? '',
      weight: json['weight'] ?? '',
      itemTotal: (json['item_total'] ?? 0).toDouble(),
    );
  }
}