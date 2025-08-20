class ApiEndpoints {
  static const String baseUrl = 'https://api.dailygro.com';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String userOrders = '/user/orders';
  
  // Vendor endpoints
  static const String vendorDashboard = '/vendor/dashboard';
  static const String vendorProducts = '/vendor/products';
  static const String vendorOrders = '/vendor/orders';
  static const String vendorEarnings = '/vendor/earnings';
  
  // Rider endpoints
  static const String riderDashboard = '/rider/dashboard';
  static const String riderOrders = '/rider/orders';
  static const String riderEarnings = '/rider/earnings';
  static const String updateOrderStatus = '/rider/orders/{id}/status';
  
  // Product endpoints
  static const String products = '/products';
  static const String categories = '/categories';
  static const String searchProducts = '/products/search';
  
  // Order endpoints
  static const String createOrder = '/orders';
  static const String orderDetails = '/orders/{id}';
  static const String cancelOrder = '/orders/{id}/cancel';
}