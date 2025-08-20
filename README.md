# DailyGro - Flutter E-commerce App

A modern Flutter e-commerce application with clean architecture and modular design.

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── routes/
│   ├── app_pages.dart          # Route definitions
│   └── app_routes.dart         # Route constants
├── themes/
│   ├── app_theme.dart          # Light/Dark theme configuration
│   ├── app_colors.dart         # Color palette
│   └── app_design_system.dart  # Design system constants
├── CommonComponents/
│   ├── CommonUtils/
│   │   ├── app_sizes.dart      # Responsive sizing utilities
│   │   ├── app_constants.dart  # App constants
│   │   └── currency_constants.dart # Currency helpers
│   └── CommonWidgets/
│       ├── common_button.dart  # Reusable button component
│       ├── common_textfield.dart # Reusable input field
│       ├── shimmer_widget.dart # Loading shimmer effect
│       └── lottie_loader.dart  # Lottie animation loader
├── controllers/
│   ├── auth_controller.dart    # Authentication logic
│   ├── cart_controller.dart    # Shopping cart management
│   ├── home_controller.dart    # Home screen logic
│   ├── products_controller.dart # Product management
│   ├── orders_controller.dart  # Order management
│   ├── wallet_controller.dart  # Wallet functionality
│   ├── profile_controller.dart # User profile
│   ├── user_controller.dart    # User data management
│   ├── address_controller.dart # Address management
│   ├── coupon_controller.dart  # Coupon system
│   └── wishlist_controller.dart # Wishlist functionality
├── models/
│   ├── user_model.dart         # User data model
│   ├── cart_item_model.dart    # Cart item structure
│   ├── order_model.dart        # Order data model
│   ├── address_model.dart      # Address structure
│   ├── coupon_model.dart       # Coupon data model
│   └── wallet_transaction_model.dart # Wallet transactions
└── modules/
    ├── auth/
    │   ├── login_view.dart     # Login screen
    │   └── login_controller.dart # Login logic
    ├── home/
    │   ├── controller/
    │   │   └── home_controller.dart
    │   ├── views/
    │   │   ├── home_view.dart
    │   │   └── widgets/
    │   │       ├── home_header.dart
    │   │       ├── category_list.dart
    │   │       ├── featured_products.dart
    │   │       ├── recommended_products.dart
    │   │       ├── wallet_summary.dart
    │   │       └── shimmer_home_loader.dart
    │   ├── models/
    │   │   ├── home_product_model.dart
    │   │   └── category_model.dart
    │   ├── data/
    │   │   ├── dummy_home_data.dart
    │   │   └── category_data.dart
    │   └── bindings/
    │       └── home_binding.dart
    ├── products/
    │   ├── products_list_view.dart
    │   └── products_controller.dart
    ├── cart/
    │   ├── cart_view.dart
    │   └── cart_controller.dart
    ├── orders/
    │   ├── orders_view.dart
    │   └── orders_controller.dart
    ├── profile/
    │   ├── profile_view.dart
    │   └── profile_controller.dart
    └── bottom_navigation_bar/
        └── bottom_nav_view.dart
```

## Architecture

- **GetX Pattern**: State management and dependency injection
- **Modular Structure**: Feature-based organization
- **Responsive Design**: Adaptive UI for different screen sizes
- **Clean Architecture**: Separation of concerns

## Key Features

- User Authentication
- Product Catalog
- Shopping Cart
- Order Management
- Wallet System
- User Profile
- Wishlist
- Coupon System
- Address Management

## Development Setup

1. Ensure Flutter SDK is installed
2. Run `flutter pub get` to install dependencies
3. Use `flutter run` for development
4. Use `flutter build` for production builds

## Code Quality

- Lint rules configured in `analysis_options.yaml`
- Consistent code formatting
- Proper error handling
- Type safety enforced