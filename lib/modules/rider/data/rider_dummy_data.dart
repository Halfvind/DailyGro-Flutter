import '../models/rider_models.dart';

class RiderDummyData {
  static RiderProfile riderProfile = RiderProfile(
    id: 'rider_001',
    name: 'John Rider',
    phone: '+1234567890',
    email: 'john.rider@example.com',
    address: '123 Rider Street, City',
    vehicleType: 'Motorcycle',
    vehicleNumber: 'ABC-1234',
    licenseNumber: 'DL123456789',
    bankAccount: '1234567890',
    ifscCode: 'BANK0001234',
    profileImage: 'assets/images/rider_avatar.png',
    idProof: 'assets/images/id_proof.png',
    isOnline: true,
    isVerified: true,
  );

  static List<RiderOrder> availableOrders = [
    RiderOrder(
      id: 'order_001',
      customerId: 'cust_001',
      customerName: 'Alice Johnson',
      customerPhone: '+1234567891',
      customerAddress: '456 Customer Ave, City',
      vendorId: 'vendor_001',
      vendorName: 'Fresh Mart',
      vendorAddress: '789 Vendor St, City',
      items: [
        OrderItem(name: 'Apples', quantity: 2, price: 5.99),
        OrderItem(name: 'Bread', quantity: 1, price: 2.50),
      ],
      totalAmount: 8.49,
      deliveryFee: 2.99,
      status: 'pending',
      createdAt: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    RiderOrder(
      id: 'order_002',
      customerId: 'cust_002',
      customerName: 'Bob Smith',
      customerPhone: '+1234567892',
      customerAddress: '321 Oak Street, City',
      vendorId: 'vendor_002',
      vendorName: 'Green Grocers',
      vendorAddress: '654 Pine Ave, City',
      items: [
        OrderItem(name: 'Milk', quantity: 1, price: 3.99),
        OrderItem(name: 'Eggs', quantity: 12, price: 4.50),
      ],
      totalAmount: 8.49,
      deliveryFee: 2.99,
      status: 'pending',
      createdAt: DateTime.now().subtract(Duration(minutes: 10)),
    ),
  ];

  static List<RiderOrder> myOrders = [
    RiderOrder(
      id: 'order_003',
      customerId: 'cust_003',
      customerName: 'Carol Davis',
      customerPhone: '+1234567893',
      customerAddress: '987 Elm Street, City',
      vendorId: 'vendor_001',
      vendorName: 'Fresh Mart',
      vendorAddress: '789 Vendor St, City',
      items: [
        OrderItem(name: 'Bananas', quantity: 3, price: 2.99),
      ],
      totalAmount: 2.99,
      deliveryFee: 2.99,
      status: 'accepted',
      createdAt: DateTime.now().subtract(Duration(hours: 1)),
      acceptedAt: DateTime.now().subtract(Duration(minutes: 55)),
    ),
  ];

  static List<RiderEarnings> earnings = [
    RiderEarnings(
      id: 'earn_001',
      orderId: 'order_101',
      amount: 2.99,
      date: DateTime.now().subtract(Duration(days: 1)),
      type: 'delivery',
    ),
    RiderEarnings(
      id: 'earn_002',
      orderId: 'order_102',
      amount: 3.50,
      date: DateTime.now().subtract(Duration(days: 1)),
      type: 'delivery',
    ),
    RiderEarnings(
      id: 'earn_003',
      orderId: 'order_103',
      amount: 5.00,
      date: DateTime.now().subtract(Duration(days: 2)),
      type: 'bonus',
    ),
  ];

  static List<WithdrawalRequest> withdrawals = [
    WithdrawalRequest(
      id: 'withdraw_001',
      amount: 50.00,
      requestDate: DateTime.now().subtract(Duration(days: 3)),
      status: 'paid',
      bankAccount: '****7890',
      processedDate: DateTime.now().subtract(Duration(days: 1)),
    ),
    WithdrawalRequest(
      id: 'withdraw_002',
      amount: 25.00,
      requestDate: DateTime.now().subtract(Duration(hours: 2)),
      status: 'pending',
      bankAccount: '****7890',
    ),
  ];
}