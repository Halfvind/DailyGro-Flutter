class RiderOrder {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String vendorId;
  final String vendorName;
  final String vendorAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final String status; // pending, accepted, picked, delivered, cancelled
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? pickedAt;
  final DateTime? deliveredAt;

  RiderOrder({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.vendorId,
    required this.vendorName,
    required this.vendorAddress,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.pickedAt,
    this.deliveredAt,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class RiderEarnings {
  final String id;
  final String orderId;
  final double amount;
  final DateTime date;
  final String type; // delivery, bonus, penalty

  RiderEarnings({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.date,
    required this.type,
  });
}

class WithdrawalRequest {
  final String id;
  final double amount;
  final DateTime requestDate;
  final String status; // pending, approved, paid, rejected
  final String? bankAccount;
  final DateTime? processedDate;

  WithdrawalRequest({
    required this.id,
    required this.amount,
    required this.requestDate,
    required this.status,
    this.bankAccount,
    this.processedDate,
  });
}

class RiderProfile {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String vehicleType;
  final String vehicleNumber;
  final String licenseNumber;
  final String bankAccount;
  final String ifscCode;
  final String profileImage;
  final String idProof;
  final bool isOnline;
  final bool isVerified;

  RiderProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.licenseNumber,
    required this.bankAccount,
    required this.ifscCode,
    required this.profileImage,
    required this.idProof,
    required this.isOnline,
    required this.isVerified,
  });
}