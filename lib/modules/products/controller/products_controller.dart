// lib/modules/products/products_controller.dart

import 'package:get/get.dart';
import '../../home/models/home_product_model.dart';

class ProductsController extends GetxController {
  final RxList<HomeProductModel> allProducts = <HomeProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyProducts();
  }

  void loadDummyProducts() {
    allProducts.assignAll([
      HomeProductModel(
        id: 101,
        name: 'Apples',
        rating: 4.5,
        categoryId: 1,
        isFeatured: true,
        description: 'Crisp, sweet apples fresh from the orchard.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg',
        reviewCount: 342,
        isAvailable: true,
        variants: [ProductVariant(unit: "500g", price: 50), ProductVariant(unit: "1kg", price: 100)], category: '',
      ),
      HomeProductModel(
        id: 102,
        name: 'Bananas',
        rating: 4.3,
        categoryId: 1,
        isFeatured: true,
        description: 'Naturally sweet and full of energy.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg',
        reviewCount: 287,
        isAvailable: true,
        variants: [ProductVariant(unit: "500g", price: 30), ProductVariant(unit: "1kg", price: 55)], category: '',
      ),
      HomeProductModel(
        id: 103,
        name: 'Grapes',
        rating: 4.5,
        categoryId: 1,
        description: 'Juicy grapes perfect for snacking.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/13/2018_Grapes.jpg',
        reviewCount: 198,
        isAvailable: true,
        variants: [ProductVariant(unit: "500g", price: 80), ProductVariant(unit: "1kg", price: 150)], category: '',
      ),
      HomeProductModel(
        id: 104,
        name: 'Mangoes',
        rating: 4.7,
        categoryId: 1,
        description: 'Sweet and aromatic tropical mangoes.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Hapus_Mango.jpg',
        reviewCount: 455,
        isAvailable: true,
        variants: [ProductVariant(unit: "500g", price: 120), ProductVariant(unit: "1kg", price: 220)], category: '',
      ),
    ]);
  }
}
