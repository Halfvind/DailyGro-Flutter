class CategoryModel {
  final int categoryId;
  final String name;
  final String? image;
  final String? icon;
  final String? color;
  final String status;
  final int sortOrder;
  final int productCount;
  final DateTime createdAt;

  CategoryModel({
    required this.categoryId,
    required this.name,
    this.image,
    this.icon,
    this.color,
    required this.status,
    required this.sortOrder,
    required this.productCount,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      icon: json['icon'],
      color: json['color'],
      status: json['status'] ?? 'active',
      sortOrder: json['sort_order'] ?? 0,
      productCount: json['product_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'image': image,
      'icon': icon,
      'color': color,
      'status': status,
      'sort_order': sortOrder,
      'product_count': productCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}