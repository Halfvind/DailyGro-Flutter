class AddressModel {
  final int addressId;
  final int userId;
  final String title;
  final String name;
  final String phone;
  final String addressLine;
  final String? landmark;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;
  late final bool isDefault;
  final String addressType;
  final String createdAt;

  AddressModel({
    required this.addressId,
    required this.userId,
    required this.title,
    required this.name,
    required this.phone,
    required this.addressLine,
    this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    required this.isDefault,
    required this.addressType,
    required this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine: json['address_line'] ?? '',
      landmark: json['landmark'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      isDefault: json['is_default'] == 1,
      addressType: json['address_type'] ?? 'home',
      createdAt: json['created_at'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'user_id': userId,
      'title': title,
      'name': name,
      'phone': phone,
      'address_line': addressLine,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault ? 1 : 0,
      'address_type': addressType,
    };
  }

  String get fullAddress {
    return '$addressLine${landmark != null ? ', $landmark' : ''}, $city, $state - $pincode';
  }
}