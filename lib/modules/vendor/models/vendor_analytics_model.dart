class VendorAnalyticsModel {
  final double todaysSales;
  final double totalEarnings;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double walletBalance;
  final int totalProducts;
  final int lowStockProducts;

  VendorAnalyticsModel({
    required this.todaysSales,
    required this.totalEarnings,
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.walletBalance,
    required this.totalProducts,
    required this.lowStockProducts,
  });

  factory VendorAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return VendorAnalyticsModel(
      todaysSales: (json['todays_sales'] ?? 0.0).toDouble(),
      totalEarnings: (json['total_earnings'] ?? 0.0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
      walletBalance: (json['wallet_balance'] ?? 0.0).toDouble(),
      totalProducts: json['total_products'] ?? 0,
      lowStockProducts: json['low_stock_products'] ?? 0,
    );
  }
}