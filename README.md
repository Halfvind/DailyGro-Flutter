# DailyGro - Flutter E-commerce App

A modern Flutter e-commerce application with clean architecture and role-based functionality.

## Project Structure

```
dailygro/
├── lib/                          # Flutter source code
│   ├── CommonComponents/         # Shared components
│   ├── controllers/             # Global controllers
│   ├── data/api/               # API services
│   ├── models/                 # Data models
│   ├── modules/               # Feature modules
│   │   ├── auth/             # Authentication
│   │   ├── user/             # User functionality
│   │   ├── vendor/           # Vendor functionality
│   │   ├── rider/            # Rider functionality
│   │   └── home/             # Home screens
│   ├── routes/               # App routing
│   ├── services/             # Core services
│   └── themes/               # App theming
├── php/                      # Backend API files
│   ├── user/                # User APIs
│   ├── vendor/              # Vendor APIs
│   ├── rider/               # Rider APIs
│   ├── config.php           # Database config
│   ├── login.php            # Login API
│   ├── logout.php           # Logout API
│   └── user_registration.php # Registration/Update API
├── sql/                     # Database structure
│   └── create_all_tables.sql # Complete database
└── assets/                  # App assets
```

## Features

- **Multi-Role System**: User, Vendor, Rider
- **Authentication**: Registration, Login, Auto-login
- **Profile Management**: Role-based profile handling
- **Session Management**: Persistent login with SharedPreferences
- **Clean Architecture**: Modular design with proper separation

## Setup

1. **Database**: Import `sql/create_all_tables.sql`
2. **Backend**: Copy `php/` to XAMPP htdocs
3. **Flutter**: Run `flutter pub get` and `flutter run`

## API Endpoints

- `POST /login.php` - Login
- `POST /user_registration.php` - Register
- `PUT /user_registration.php` - Update profile
- `GET /user/get_user_profile.php?id=6` - User profile
- `GET /vendor/get_vendor_profile.php?id=6` - Vendor profile
- `GET /rider/get_rider_profile.php?id=6` - Rider profile