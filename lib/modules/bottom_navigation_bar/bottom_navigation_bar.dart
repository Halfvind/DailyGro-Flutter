import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cart/cart_view.dart';
import '../home/views/home_view.dart';
import '../orders/views/orders_view.dart';
import '../profile/views/profile_view.dart';
import 'navigation_controller.dart';

class BottomNavigationView extends StatelessWidget {
  final navigationController = Get.put(NavigationController());

  BottomNavigationView({Key? key}) : super(key: key) {
    // Check if there's an argument passed for the initial index
    final int? initialIndex = Get.arguments as int?;
    if (initialIndex != null && initialIndex >= 0 && initialIndex < 4) {
      navigationController.changeTabIndex(initialIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tabIndex,
            children: [
              HomeView(),
              CartView(),
              OrdersView(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.black54,
            selectedItemColor: Colors.green,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: [
              _bottomNavigationBarItem(
                icon: Icons.home,
                label: 'Home',
              ),
              _bottomNavigationBarItem(
                icon: Icons.shopping_cart,
                label: 'Cart',
              ),
              _bottomNavigationBarItem(
                icon: Icons.list_alt,
                label: 'Orders',
              ),
              _bottomNavigationBarItem(
                icon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  _bottomNavigationBarItem({IconData? icon, String? label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}