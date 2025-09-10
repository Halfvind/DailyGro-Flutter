import 'dart:convert';

class ProductsBycategoryIdModel {
  String? status;
  String? message;
  List<Product>? products;
  int? totalCount;

  ProductsBycategoryIdModel({
    this.status,
    this.message,
    this.products,
    this.totalCount,
  });

  factory ProductsBycategoryIdModel.fromRawJson(String str) => ProductsBycategoryIdModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductsBycategoryIdModel.fromJson(Map<String, dynamic> json) => ProductsBycategoryIdModel(
    status: json["status"],
    message: json["message"],
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    totalCount: json["total_count"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "total_count": totalCount,
  };
}

class Product {
  int? productId;
  int? vendorId;
  int? categoryId;
  String? name;
  String? description;
  int? price;
  int? originalPrice;
  int? stockQuantity;
  String? unit;
  String? weight;
  String? image;
  dynamic images;
  bool? isFeatured;
  bool? isRecommended;
  double? rating;
  int? avgRating;
  int? reviewCount;
  String? categoryName;
  String? vendorName;
  String? vendorOwnerName;
  int? vendorRating;
  int? discountPercentage;
  DateTime? createdAt;

  Product({
    this.productId,
    this.vendorId,
    this.categoryId,
    this.name,
    this.description,
    this.price,
    this.originalPrice,
    this.stockQuantity,
    this.unit,
    this.weight,
    this.image,
    this.images,
    this.isFeatured,
    this.isRecommended,
    this.rating,
    this.avgRating,
    this.reviewCount,
    this.categoryName,
    this.vendorName,
    this.vendorOwnerName,
    this.vendorRating,
    this.discountPercentage,
    this.createdAt,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    vendorId: json["vendor_id"],
    categoryId: json["category_id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    originalPrice: json["original_price"],
    stockQuantity: json["stock_quantity"],
    unit: json["unit"],
    weight: json["weight"],
    image: json["image"],
    images: json["images"],
    isFeatured: json["is_featured"],
    isRecommended: json["is_recommended"],
    rating: json["rating"]?.toDouble(),
    avgRating: json["avg_rating"],
    reviewCount: json["review_count"],
    categoryName: json["category_name"],
    vendorName: json["vendor_name"],
    vendorOwnerName: json["vendor_owner_name"],
    vendorRating: json["vendor_rating"],
    discountPercentage: json["discount_percentage"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    'vendor_id': vendorId,
    "category_id": categoryId,
    "name": name,
    "description": description,
    "price": price,
    "original_price": originalPrice,
    "stock_quantity": stockQuantity,
    "unit": unit,
    "weight": weight,
    "image": image,
    "images": images,
    "is_featured": isFeatured,
    "is_recommended": isRecommended,
    "rating": rating,
    "avg_rating": avgRating,
    "review_count": reviewCount,
    "category_name": categoryName,
    "vendor_name": vendorName,
    "vendor_owner_name": vendorOwnerName,
    "vendor_rating": vendorRating,
    "discount_percentage": discountPercentage,
    "created_at": createdAt?.toIso8601String(),
  };
}
