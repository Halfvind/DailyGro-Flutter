class VendorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String address;
  final bool isActive;
  final double rating;
  final int totalOrders;
  final double totalEarnings;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.address,
    required this.isActive,
    required this.rating,
    required this.totalOrders,
    required this.totalEarnings,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      businessName: json['business_name'] ?? '',
      address: json['address'] ?? '',
      isActive: json['is_active'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      totalEarnings: (json['total_earnings'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'business_name': businessName,
      'address': address,
      'is_active': isActive,
      'rating': rating,
      'total_orders': totalOrders,
      'total_earnings': totalEarnings,
    };
  }
}