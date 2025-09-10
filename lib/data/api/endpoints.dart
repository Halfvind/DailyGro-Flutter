class ApiEndpoints {
  static const String baseUrl = 'http://localhost/dailygro/api/';
  
  // Common Auth endpoints
  static const String login = 'login';
  static const String logout = 'logout';
  
  // User endpoints
  static const String userRegister = 'user_registration';
  static const String userProfile = 'user/get_user_profile';
  static const String userUpdate = 'user_registration';
  static const String userOrders = '/user/orders';
  static const String products = 'products';

  // Vendor endpoints
  static const String vendorRegister = 'user_registration';
  static const String vendorProfile = 'vendor/get_vendor_profile';
  static const String vendorUpdate = 'user_registration';
  static const String vendorDashboard = '/vendor/dashboard';
  static const String vendorProducts = '/vendor/products';
  static const String vendorOrders = '/vendor/orders';
  
  // Rider endpoints8
  static const String riderRegister = 'user_registration';
  static const String riderProfile = 'rider/get_rider_profile';
  static const String riderUpdate = 'user_registration';
  static const String riderDashboard = '/rider/dashboard';
  static const String riderOrders = '/rider/orders';
  static const String updateOrderStatus = '/rider/orders/{id}/status';
  
  // Product endpoints
  //static const String products = '/products';
  static const String categories = '/categories';
  static const String searchProducts = '/products/search';
  
  // Order endpoints
  static const String createOrder = '/orders';
  static const String orderDetails = '/orders/{id}';
  static const String cancelOrder = '/orders/{id}/cancel';
}