import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cart/cart_view.dart';
import '../home/views/home_view.dart';
import '../orders/views/orders_view.dart';
import '../profile/views/profile_view.dart';


class NavigationController extends GetxController {
  // Observable current index
  var tabIndex = 0;

  // List of widgets for each tab
  final List<Widget> screens = [
    HomeView(),
    CartView(),

   // ProductsListView(),
    OrdersView(),
    ProfileView(),
  ];

  // Getter for current screen
  Widget get currentScreen => screens[tabIndex];

  // Method to change tab
  void changeTabIndex(int index) {
    if (index != tabIndex) {
      tabIndex = index;
      update();
    }
  }
}
