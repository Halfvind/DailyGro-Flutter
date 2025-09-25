import 'dart:convert';

class ProductDetailModel {
  String status;
  String message;
  Product? product;
  List<SimilarProduct> similarProducts;

  ProductDetailModel({
    required this.status,
    required this.message,
    this.product,
    required this.similarProducts,
  });

  factory ProductDetailModel.fromRawJson(String str) =>
      ProductDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        product: json["product"] != null
            ? Product.fromJson(json["product"])
            : null,
        similarProducts: json["similar_products"] != null
            ? List<SimilarProduct>.from(
            json["similar_products"].map((x) => SimilarProduct.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "product": product?.toJson(),
    "similar_products": List<dynamic>.from(similarProducts.map((x) => x.toJson())),
  };
}

class Product {
  int productId;
  String name;
  double price;
  double originalPrice;
  String discountType;
  String unit;
  String weight;
  String? image;
  double rating;
  String description;
  int categoryId;

  Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountType,
    required this.unit,
    required this.weight,
    this.image,
    required this.rating,
    required this.description,
    required this.categoryId,
  });

  factory Product.fromRawJson(String str) =>
      Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"] ?? 0,
    name: json["name"] ?? "",
    price: double.tryParse(json["price"].toString()) ?? 0.0,
    originalPrice: double.tryParse(json["original_price"].toString()) ?? 0.0,
    discountType: json["discount_type"] ?? "",
    unit: json["unit"] ?? "",
    weight: json["weight"] ?? "",
    image: json["image"],
    rating: double.tryParse(json["rating"].toString()) ?? 0.0,
    description: json["description"] ?? "",
    categoryId: json["category_id"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "name": name,
    "price": price,
    "original_price": originalPrice,
    "discount_type": discountType,
    "unit": unit,
    "weight": weight,
    "image": image,
    "rating": rating,
    "description": description,
    "category_id": categoryId,
  };
}

class SimilarProduct {
  int productId;
  String name;
  double price;
  double originalPrice;
  String discountType;
  String unit;
  String weight;
  String? image;
  double rating;

  SimilarProduct({
    required this.productId,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountType,
    required this.unit,
    required this.weight,
    this.image,
    required this.rating,
  });

  factory SimilarProduct.fromRawJson(String str) =>
      SimilarProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SimilarProduct.fromJson(Map<String, dynamic> json) => SimilarProduct(
    productId: json["product_id"] ?? 0,
    name: json["name"] ?? "",
    price: double.tryParse(json["price"].toString()) ?? 0.0,
    originalPrice: double.tryParse(json["original_price"].toString()) ?? 0.0,
    discountType: json["discount_type"] ?? "",
    unit: json["unit"] ?? "",
    weight: json["weight"]?.toString() ?? "",
    image: json["image"],
    rating: double.tryParse(json["rating"].toString()) ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "name": name,
    "price": price,
    "original_price": originalPrice,
    "discount_type": discountType,
    "unit": unit,
    "weight": weight,
    "image": image,
    "rating": rating,
  };
}
