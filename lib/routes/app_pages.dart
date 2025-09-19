import 'package:get/get.dart';

import '../data/api/api_client.dart';
import '../data/api/services/user_api_service.dart';
import '../data/api/services/vendor_api_service.dart';
import '../data/api/services/rider_api_service.dart';
import '../data/api/services/profile_api_service.dart';
import '../data/repositories/auth_repository.dart';
import '../CommonComponents/controllers/global_controller.dart';
import '../modules/address/repositories/address_repository.dart';
import '../modules/wallet/repositories/wallet_repository.dart';
import '../modules/vendor/repositories/vendor_repository.dart';
import '../data/repositories/rider_repository.dart';
import '../models/cart_item_model.dart';
import '../modules/auth/login_controller.dart';
import '../modules/auth/login_view.dart';
import '../modules/auth/role_selector.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../modules/orders/views/order_success_screen.dart';
import '../modules/vendor/controllers/vendor_controller.dart';
import '../modules/auth/user_signup_screen.dart';
import '../modules/auth/vendor_signup_screen.dart';
import '../modules/vendor/repositories/vendor_repository.dart';
import '../modules/vendor/views/vendor_dashboard.dart';
import '../modules/vendor/views/vendor_products.dart';
import '../modules/vendor/views/vendor_orders_screen.dart';
import '../modules/vendor/views/vendor_stock_management.dart';
import '../modules/vendor/views/add_product_screen.dart';
import '../modules/vendor/views/vendor_analytics_screen.dart';
import '../modules/vendor/views/vendor_earnings_screen.dart';
import '../modules/vendor/views/vendor_profile_screen.dart';
import '../modules/rider/controllers/rider_controller.dart';
import '../modules/rider/views/rider_dashboard.dart';
import '../modules/rider/views/rider_orders_screen.dart';
import '../modules/auth/rider_signup_screen.dart';
import '../modules/orders/views/order_tracking_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;
  
  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.roleSelector,
      page: () => const RoleSelector(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ApiClient>()) Get.lazyPut(() => ApiClient());
        if (!Get.isRegistered<UserApiService>()) Get.lazyPut(() => UserApiService());
        if (!Get.isRegistered<VendorApiService>()) Get.lazyPut(() => VendorApiService());
        if (!Get.isRegistered<RiderApiService>()) Get.lazyPut(() => RiderApiService());
        if (!Get.isRegistered<AuthRepository>()) Get.lazyPut(() => AuthRepository());
        Get.lazyPut(() => LoginController());
      }),
    ),
    GetPage(
      name: Routes.loginView,
      page: () => LoginView(),
    ),
    GetPage(
      name: Routes.home,
      page: () => BottomNavigationView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ApiClient>()) Get.lazyPut(() => ApiClient());
        if (!Get.isRegistered<GlobalController>()) Get.lazyPut(() => GlobalController());
        if (!Get.isRegistered<ProfileApiService>()) Get.lazyPut(() => ProfileApiService());
        if (!Get.isRegistered<AddressRepository>()) Get.lazyPut(() => AddressRepository());
        if (!Get.isRegistered<WalletRepository>()) Get.lazyPut(() => WalletRepository());
      }),
    ),
    GetPage(
      name: Routes.bottomBar,
      page: () => BottomNavigationView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ApiClient>()) Get.lazyPut(() => ApiClient());
        if (!Get.isRegistered<GlobalController>()) Get.lazyPut(() => GlobalController());
        if (!Get.isRegistered<ProfileApiService>()) Get.lazyPut(() => ProfileApiService());
        if (!Get.isRegistered<AddressRepository>()) Get.lazyPut(() => AddressRepository());
        if (!Get.isRegistered<WalletRepository>()) Get.lazyPut(() => WalletRepository());
      }),
    ),
    GetPage(
      name: Routes.userSignup,
      page: () => const UserSignupScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ApiClient>()) Get.lazyPut(() => ApiClient());
        if (!Get.isRegistered<UserApiService>()) Get.lazyPut(() => UserApiService());
      }),
    ),
    GetPage(
      name: Routes.vendorSignup,
      page: () => const VendorSignupScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ApiClient>()) Get.lazyPut(() => ApiClient());
        if (!Get.isRegistered<VendorApiService>()) Get.lazyPut(() => VendorApiService());
      }),
    ),
    GetPage(
      name: Routes.riderSignup,
      page: () => const RiderSignupScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ApiClient>()) Get.lazyPut(() => ApiClient());
        if (!Get.isRegistered<RiderApiService>()) Get.lazyPut(() => RiderApiService());
      }),
    ),
    GetPage(
      name: Routes.vendorDashboard,
      page: () => const VendorDashboard(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ApiClient>()) Get.lazyPut(() => ApiClient());
        if (!Get.isRegistered<VendorRepository>()) Get.lazyPut(() => VendorRepository());
        if (!Get.isRegistered<VendorController>()) Get.lazyPut(() => VendorController());
      }),
    ),
    GetPage(
      name: Routes.vendorProducts,
      page: () => const VendorProducts(),
    ),
    GetPage(
      name: Routes.vendorOrders,
      page: () => const VendorOrdersScreen(),
    ),
    GetPage(
      name: Routes.vendorStock,
      page: () => const VendorStockManagement(),
    ),
    GetPage(
      name: Routes.vendorAddProduct,
      page: () => const AddProductScreen(),
    ),
    GetPage(
      name: Routes.vendorAnalytics,
      page: () => const VendorAnalyticsScreen(),
    ),
    GetPage(
      name: Routes.vendorEarnings,
      page: () => const VendorEarningsScreen(),
    ),
    GetPage(
      name: Routes.vendorProfile,
      page: () => const VendorProfileScreen(),
    ),
    GetPage(
      name: Routes.riderDashboard,
      page: () => RiderDashboard(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ApiClient>()) Get.lazyPut(() => ApiClient());
        if (!Get.isRegistered<RiderRepository>()) Get.lazyPut(() => RiderRepository());
        if (!Get.isRegistered<RiderController>()) Get.lazyPut(() => RiderController());
      }),
    ),
    GetPage(
      name: Routes.riderOrders,
      page: () => RiderOrdersScreen(),
    ),
    GetPage(
      name: Routes.productDetail,
      page: () => OrderSuccessScreen(
        orderId: Get.parameters['orderId'] ?? '',
        orderAmount: double.tryParse(Get.parameters['amount'] ?? '0') ?? 0.0,
        orderedItems: (Get.arguments as List<CartItem>?) ?? <CartItem>[],
      ),
    ),
    GetPage(
      name: Routes.orderTracking,
      page: () => OrderTrackingScreen(
        orderId: Get.parameters['orderId'] ?? '',
      ),
    ),
  ];
}
