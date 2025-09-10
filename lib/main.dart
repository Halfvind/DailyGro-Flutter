
import 'package:dailygro/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'CommonComponents/CommonUtils/app_sizes.dart';
import 'CommonComponents/controllers/global_controller.dart';
import 'controllers/orders_controller.dart';
import 'controllers/integrated_order_controller.dart';
import 'controllers/user_controller.dart';
import 'data/api/api_client.dart';
import 'data/api/services/user_api_service.dart';
import 'data/api/services/vendor_api_service.dart';
import 'data/api/services/rider_api_service.dart';
import 'data/api/services/profile_api_service.dart';

import 'modules/coupon/controllers/coupon_controller.dart';
import 'modules/vendor/repositories/vendor_repository.dart';
import 'modules/rider/repositories/rider_repository.dart';
import 'modules/address/repositories/address_repository.dart';
import 'modules/category/repositories/category_repository.dart';
import 'modules/product/repositories/product_repository.dart';
import 'modules/coupon/repositories/coupon_repository.dart';
import 'modules/wallet/controllers/wallet_controller.dart';
import 'modules/wallet/repositories/wallet_repository.dart';
import 'modules/products/repositories/products_repository.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core services
  await Get.putAsync(() => NotificationService().init());
  await Get.putAsync(() => LocationService().init());
  
  // Initialize API client and repositories
  Get.put(ApiClient());
  //Get.put(UserRepository());
  Get.put(VendorRepository());
  Get.put(RiderRepository());
  Get.put(AddressRepository());
  Get.put(CategoryRepository());
  Get.put(ProductRepository());
  Get.put(CouponRepository());
  Get.put(WalletRepository());
  Get.put(ProductsRepository());
  
  // Initialize global controllers
  Get.put(GlobalController());
  Get.put(UserApiService());
  Get.put(VendorApiService());
  Get.put(RiderApiService());
  Get.put(ProfileApiService());
  
  // Initialize feature controllers

  Get.put(CouponController());
  Get.put(OrdersController());
  Get.put(IntegratedOrderController());
  Get.put(UserController());

  Get.put(WalletController());


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