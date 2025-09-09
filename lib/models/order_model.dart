class OrderModel {
  final int orderId;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String deliveryAddress;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;

  OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.deliveryAddress,
    required this.createdAt,
    this.estimatedDelivery,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      estimatedDelivery: json['estimated_delivery'] != null 
          ? DateTime.tryParse(json['estimated_delivery']) 
          : null,
    );
  }
}

class OrderTrackingModel {
  final int orderId;
  final String orderNumber;
  final String currentStatus;
  final StatusInfo? currentStatusInfo;
  final DateTime? estimatedDelivery;
  final DeliveryAddress deliveryAddress;
  final RiderInfo? riderInfo;
  final List<StatusStep> statusSteps;
  final List<TrackingHistory> trackingHistory;
  final DateTime createdAt;

  OrderTrackingModel({
    required this.orderId,
    required this.orderNumber,
    required this.currentStatus,
    this.currentStatusInfo,
    this.estimatedDelivery,
    required this.deliveryAddress,
    this.riderInfo,
    required this.statusSteps,
    required this.trackingHistory,
    required this.createdAt,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      currentStatus: json['current_status'] ?? '',
      currentStatusInfo: json['current_status_info'] != null 
          ? StatusInfo.fromJson(json['current_status_info']) 
          : null,
      estimatedDelivery: json['estimated_delivery'] != null 
          ? DateTime.tryParse(json['estimated_delivery']) 
          : null,
      deliveryAddress: DeliveryAddress.fromJson(json['delivery_address'] ?? {}),
      riderInfo: json['rider_info'] != null 
          ? RiderInfo.fromJson(json['rider_info']) 
          : null,
      statusSteps: (json['status_steps'] as List? ?? [])
          .map((step) => StatusStep.fromJson(step))
          .toList(),
      trackingHistory: (json['tracking_history'] as List? ?? [])
          .map((history) => TrackingHistory.fromJson(history))
          .toList(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class StatusInfo {
  final String title;
  final String description;

  StatusInfo({required this.title, required this.description});

  factory StatusInfo.fromJson(Map<String, dynamic> json) {
    return StatusInfo(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class DeliveryAddress {
  final String name;
  final String phone;
  final String address;

  DeliveryAddress({required this.name, required this.phone, required this.address});

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class RiderInfo {
  final String name;
  final String phone;
  final String vehicleNumber;

  RiderInfo({required this.name, required this.phone, required this.vehicleNumber});

  factory RiderInfo.fromJson(Map<String, dynamic> json) {
    return RiderInfo(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
    );
  }
}

class StatusStep {
  final String status;
  final String title;
  final String description;
  final bool completed;
  final bool active;

  StatusStep({
    required this.status,
    required this.title,
    required this.description,
    required this.completed,
    required this.active,
  });

  factory StatusStep.fromJson(Map<String, dynamic> json) {
    return StatusStep(
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
      active: json['active'] ?? false,
    );
  }
}

class TrackingHistory {
  final String status;
  final String message;
  final String location;
  final DateTime timestamp;

  TrackingHistory({
    required this.status,
    required this.message,
    required this.location,
    required this.timestamp,
  });

  factory TrackingHistory.fromJson(Map<String, dynamic> json) {
    return TrackingHistory(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      location: json['location'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}