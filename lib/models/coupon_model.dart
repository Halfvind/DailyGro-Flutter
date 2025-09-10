class CouponModel {
  final int couponId;
  final String code;
  final String title;
  final String description;
  final String discountType;
  final double discountValue;
  final double minOrderAmount;
  final double maxDiscount;
  final int? usageLimit;
  final int usedCount;
  final String validFrom;
  final String validUntil;
  final String status;
  final String createdAt;

  CouponModel({
    required this.couponId,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    required this.maxDiscount,
    this.usageLimit,
    required this.usedCount,
    required this.validFrom,
    required this.validUntil,
    required this.status,
    required this.createdAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      couponId: json['coupon_id'] ?? 0,
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountValue: (json['discount_value'] ?? 0).toDouble(),
      minOrderAmount: (json['min_order_amount'] ?? 0).toDouble(),
      maxDiscount: (json['max_discount'] ?? 0).toDouble(),
      usageLimit: json['usage_limit'],
      usedCount: json['used_count'] ?? 0,
      validFrom: json['valid_from'] ?? '',
      validUntil: json['valid_until'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  double getDiscountAmount(double orderAmount) {
    if (orderAmount < minOrderAmount) return 0;
    
    if (discountType == 'percentage') {
      double discount = (orderAmount * discountValue) / 100;
      return maxDiscount > 0 ? discount.clamp(0, maxDiscount) : discount;
    } else {
      return discountValue;
    }
  }
}