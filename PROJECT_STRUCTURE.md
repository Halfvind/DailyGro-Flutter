# DailyGro - Multi-Role Flutter Application

## 📌 Project Overview
A comprehensive Flutter e-commerce application supporting three distinct user roles:
- **User**: End customers who browse and order products
- **Vendor**: Merchants managing their stores and products  
- **Rider**: Delivery personnel handling order fulfillment

## 🏗️ Architecture
The project follows a **modular + layered architecture**:

### Layers:
1. **Presentation Layer** → UI components in `modules/`
2. **Data Layer** → API, Database, Repositories in `data/`
3. **Service Layer** → Cross-cutting services in `services/`
4. **Shared Layer** → Common utilities in `CommonComponents/`

## 📁 Folder Structure

```
lib/
├── main.dart                        # App entry point
├── routes/                          # Centralized routing
│   ├── app_routes.dart             # Route constants
│   └── app_pages.dart              # Route definitions & bindings
│
├── themes/                          # App theming
│   ├── app_colors.dart
│   ├── app_design_system.dart
│   └── app_theme.dart
│
├── CommonComponents/                # Shared components
│   ├── CommonUtils/                # Utilities & constants
│   ├── CommonWidgets/              # Reusable widgets
│   └── controllers/                # Global controllers
│       └── global_controller.dart
│
├── modules/                         # Feature modules by role
│   ├── splash/                     # App initialization
│   │   └── splash_view.dart
│   │
│   ├── auth/                       # Authentication
│   │   ├── role_selector.dart      # Role selection screen
│   │   ├── login_view.dart         # Login screen
│   │   └── login_controller.dart   # Login logic
│   │
│   ├── user/                       # User module (existing)
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── views/
│   │   └── widgets/
│   │
│   ├── vendor/                     # Vendor module
│   │   ├── controllers/
│   │   │   └── vendor_controller.dart
│   │   ├── models/
│   │   │   ├── vendor_model.dart
│   │   │   └── product_model.dart
│   │   ├── views/
│   │   │   ├── vendor_dashboard.dart
│   │   │   └── vendor_products.dart
│   │   └── widgets/
│   │
│   └── rider/                      # Rider module
│       ├── controllers/
│       │   └── rider_controller.dart
│       ├── models/
│       │   ├── rider_model.dart
│       │   └── delivery_order_model.dart
│       ├── views/
│       │   ├── rider_dashboard.dart
│       │   └── rider_orders.dart
│       └── widgets/
│
├── data/                           # Data layer
│   ├── api/                        # API communication
│   │   ├── api_client.dart         # HTTP client
│   │   └── endpoints.dart          # API endpoints
│   │
│   ├── db/                         # Local database
│   │   └── local_db_helper.dart    # Local storage
│   │
│   ├── repositories/               # Business logic
│   │   ├── auth_repository.dart
│   │   ├── vendor_repository.dart
│   │   └── rider_repository.dart
│   │
│   └── models/                     # Shared models
│       └── shared_models.dart      # API response models
│
└── services/                       # Cross-cutting services
    ├── notification_service.dart   # Push notifications
    └── location_service.dart       # GPS & location
```

## 🔄 Application Flow

### 1. App Initialization
```
Splash Screen → Role Selector → Login → Dashboard
```

### 2. Role-Based Navigation
- **User Role**: Login → User Dashboard (Bottom Navigation)
- **Vendor Role**: Login → Vendor Dashboard → Product Management
- **Rider Role**: Login → Rider Dashboard → Order Management

### 3. Data Flow
```
UI → Controller → Repository → API Client → Server
                ↓
            Local Database (Cache/Offline)
```

## 🎯 Key Features by Role

### User Features
- Product browsing & search
- Shopping cart management
- Order placement & tracking
- Profile management
- Wishlist functionality

### Vendor Features
- Business dashboard with analytics
- Product inventory management
- Order management
- Earnings tracking
- Store profile management

### Rider Features
- Delivery dashboard
- Order assignment & tracking
- Route optimization
- Earnings tracking
- Online/offline status toggle

## 🔧 Technical Implementation

### State Management
- **GetX** for reactive state management
- **Controllers** for business logic
- **Repositories** for data abstraction

### Navigation
- **GetX Navigation** with named routes
- **Role-based routing** with proper bindings
- **Deep linking** support

### Data Persistence
- **API Integration** for server communication
- **Local Database** for offline functionality
- **Shared Preferences** for app settings

### Services
- **Notification Service** for push notifications
- **Location Service** for GPS tracking
- **Global Controller** for app-wide state

## 🚀 Getting Started

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the Application**
   ```bash
   flutter run
   ```

3. **Build for Production**
   ```bash
   flutter build apk --release
   flutter build ios --release
   ```

## 📱 Supported Platforms
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔐 Security Features
- Role-based authentication
- Secure API communication
- Local data encryption
- Input validation
- Error handling

This architecture ensures scalability, maintainability, and clear separation of concerns while supporting multiple user roles efficiently.