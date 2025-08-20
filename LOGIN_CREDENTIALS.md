# DailyGro - Login Credentials

## Demo Login Credentials

The application now has mock authentication for testing purposes. Use the following credentials to login:

### User Role
- **Email**: `user@dailygro.com`
- **Password**: `user123`
- **Access**: User dashboard with shopping features

### Vendor Role  
- **Email**: `vendor@dailygro.com`
- **Password**: `vendor123`
- **Access**: Vendor dashboard with product management

### Rider Role
- **Email**: `rider@dailygro.com` 
- **Password**: `rider123`
- **Access**: Rider dashboard with delivery management

### Admin Role (Bonus)
- **Email**: `admin@dailygro.com`
- **Password**: `admin123`
- **Access**: Admin features (if implemented)

## How to Login

1. **Start the app** - It will open to the Role Selector screen
2. **Choose your role** - Select User, Vendor, or Rider
3. **Enter credentials** - Use the email and password from above
4. **Login** - You'll be redirected to the appropriate dashboard

## App Flow

```
Splash Screen → Role Selector → Login → Dashboard (based on role)
```

- **User**: Goes to bottom navigation with Home, Cart, Orders, Profile
- **Vendor**: Goes to vendor dashboard with product management
- **Rider**: Goes to rider dashboard with delivery management

## Features by Role

### User Features
- Browse products and categories
- Add items to cart and wishlist
- Place orders and track them
- Manage profile and addresses
- Wallet functionality

### Vendor Features  
- View business analytics dashboard
- Manage product inventory
- Track orders and earnings
- Add/edit products
- Business profile management

### Rider Features
- View delivery dashboard
- Manage assigned orders
- Update order status (Pick Up → Deliver)
- Track earnings and deliveries
- Online/offline status toggle

## Technical Notes

- Mock authentication with 1-second delay to simulate network
- Role-based navigation and feature access
- Clean architecture with modular design
- GetX for state management
- Responsive UI design