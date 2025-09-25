import 'package:dailygro/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'CommonComponents/CommonUtils/app_sizes.dart';
import 'CommonComponents/controllers/global_controller.dart';
import 'data/api/api_client.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    runApp(const MyApp());
  } catch (e) {
    print('App initialization failed: $e');
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        AppSizes.init(context);
        
        // Initialize core dependencies
        if (!Get.isRegistered<ApiClient>()) {
          Get.put(ApiClient());
        }
        if (!Get.isRegistered<GlobalController>()) {
          Get.put(GlobalController());
        }
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DailyGro',
          theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          getPages: AppPages.pages,
          initialRoute: AppPages.initial,
        );
      },
    );
  }
}