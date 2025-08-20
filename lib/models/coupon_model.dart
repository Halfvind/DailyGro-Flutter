class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final double discount;
  final double minOrderAmount;
  final bool isActive;

  CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discount,
    required this.minOrderAmount,
    this.isActive = true,
  });
}