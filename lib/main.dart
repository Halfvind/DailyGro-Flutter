
import 'package:dailygro/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'CommonComponents/CommonUtils/app_sizes.dart';
import 'CommonComponents/controllers/global_controller.dart';
import 'controllers/address_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/coupon_controller.dart';
import 'controllers/orders_controller.dart';
import 'controllers/integrated_order_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/wallet_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'data/api/api_client.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core services
  await Get.putAsync(() => NotificationService().init());
  await Get.putAsync(() => LocationService().init());
  
  // Initialize global controllers
  Get.put(GlobalController());
  Get.put(ApiClient());
  
  // Initialize feature controllers
  Get.put(CartController());
  Get.put(CouponController());
  Get.put(OrdersController());
  Get.put(IntegratedOrderController());
  Get.put(UserController());
  Get.put(AddressController());
  Get.put(WalletController());
  Get.put(WishlistController());

  // Lock to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        AppSizes.init(context); // initialize responsive sizing

        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DailyGro',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          getPages: AppPages.pages,
          initialRoute: AppPages.initial,
        );
      },
    );
  }
}