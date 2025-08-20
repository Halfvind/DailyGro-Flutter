class DeliveryOrderModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String pickupAddress;
  final String deliveryAddress;
  final String status;
  final double amount;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;

  DeliveryOrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.status,
    required this.amount,
    required this.createdAt,
    this.estimatedDelivery,
  });

  factory DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderModel(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      pickupAddress: json['pickup_address'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      status: json['status'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      estimatedDelivery: json['estimated_delivery'] != null 
        ? DateTime.parse(json['estimated_delivery']) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
      'status': status,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
    };
  }
}