class RiderProfileModel {
  final int riderId;
  final String riderName;
  final String riderEmail;
  final String contactNumber;
  final String vehicleType;
  final String vehicleNumber;
  final String licenseNumber;
  final String verificationStatus;
  final double rating;
  final String availabilityStatus;
  final int totalDeliveries;
  final int totalOrders;
  final double totalEarnings;
  final String createdAt;

  RiderProfileModel({
    required this.riderId,
    required this.riderName,
    required this.riderEmail,
    required this.contactNumber,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.licenseNumber,
    required this.verificationStatus,
    required this.rating,
    required this.availabilityStatus,
    required this.totalDeliveries,
    required this.totalOrders,
    required this.totalEarnings,
    required this.createdAt,
  });

  factory RiderProfileModel.fromJson(Map<String, dynamic> json) {
    return RiderProfileModel(
      riderId: json['rider_id'] ?? 0,
      riderName: json['rider_name'] ?? '',
      riderEmail: json['rider_email'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      licenseNumber: json['license_number'] ?? '',
      verificationStatus: json['verification_status'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      availabilityStatus: json['availability_status'] ?? 'offline',
      totalDeliveries: json['total_deliveries'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      createdAt: json['created_at'] ?? '',
    );
  }
}