import 'cart_item_model.dart';
import 'coupon_model.dart';

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final double deliveryFee;
  final double discountAmount;
  final double finalAmount;
  final CouponModel? appliedCoupon;
  final DateTime orderDate;
  final String status;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    this.deliveryFee = 0.0,
    this.discountAmount = 0.0,
    required this.finalAmount,
    this.appliedCoupon,
    required this.orderDate,
    this.status = 'Placed',
  });
}