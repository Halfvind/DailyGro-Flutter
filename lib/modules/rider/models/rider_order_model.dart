class RiderOrderModel {
  final int orderId;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String vendorName;
  final String vendorAddress;
  final double totalAmount;
  final double deliveryFee;
  final String status;
  final String paymentMethod;
  final String createdAt;
  final List<OrderItem> items;

  RiderOrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.vendorName,
    required this.vendorAddress,
    required this.totalAmount,
    required this.deliveryFee,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
  });

  factory RiderOrderModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is String) return double.tryParse(value) ?? 0.0;
      if (value is num) return value.toDouble();
      return 0.0;
    }

    return RiderOrderModel(
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      vendorAddress: json['vendor_address'] ?? '',
      totalAmount: parseDouble(json['total_amount']),
      deliveryFee: parseDouble(json['delivery_fee']),
      status: json['status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      createdAt: json['created_at'] ?? '',
      items: (json['items'] as List?)?.map((item) => OrderItem.fromJson(item)).toList() ?? [],
      customerAddress: '',
    );
  }
}


class OrderItem {
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is String) return double.tryParse(value) ?? 0.0;
      if (value is num) return value.toDouble();
      return 0.0;
    }

    return OrderItem(
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: parseDouble(json['price']),
    );
  }
}
