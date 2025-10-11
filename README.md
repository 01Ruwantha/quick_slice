# <p align="center"><img src="https://raw.githubusercontent.com/01Ruwantha/quick_slice/main/assets/icon/icon.png?raw=true" alt="App Logo" width="200"/></p><p align="center"><img src="https://github.com/01Ruwantha/quick_slice/blob/main/assets/images/branding.png?raw=true" alt="branding png" width="200"/></p> <p align="center">Your Ultimate Pizza & Food Delivery App</p>

<div align="center">


[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-CLI-orange.svg)](https://firebase.google.com)
[![Stripe](https://img.shields.io/badge/Stripe-Payments-635bff.svg)](https://stripe.com)

*A feature-rich food delivery app built with Flutter that brings your favorite pizzas and meals right to your doorstep!*

</div>

## 📱 Screenshots

<div align="center">

| Home Screen | Product Details | Cart |
|-------------|-----------------|------|
| <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/homePage.jpg?raw=true" alt="Home page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/homePage.jpg?raw=true" alt="Home page" width="150" height="300"> |<img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/homePage.jpg?raw=true" alt="Home page" width="150" height="300"> |

| Search | Favorites | Profile |
|--------|-----------|---------|
| <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/homePage.jpg?raw=true" alt="Home page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/homePage.jpg?raw=true" alt="Home page" width="150" height="300">| <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/homePage.jpg?raw=true" alt="Home page" width="150" height="300"> |

</div>

## ✨ Features

### 🎯 Core Features
- **🍕 Multi-Category Menu** - Pizzas, Melts, Rice & Pasta, Appetizers, Desserts, and Drinks
- **🔍 Smart Search** - Find your favorite dishes instantly
- **❤️ Favorites System** - Save and quickly access your loved items
- **🛒 Smart Cart** - Customize orders with crust, size, sauce, and portion options
- **💳 Secure Payments** - Integrated Stripe payment gateway
- **👤 User Profiles** - Personalized experience with profile pictures

### 🎨 User Experience
- **📱 Beautiful UI/UX** - Modern, intuitive interface with smooth animations
- **🎯 Curved Navigation** - Elegant bottom navigation bar
- **🏷️ Smart Tagging** - Popular and Limited Time tags for quick discovery
- **📖 Expandable Descriptions** - Read more about each item with inline expansion
- **🔄 Real-time Updates** - Live menu and favorite synchronization

### 🔐 Authentication & Security
- **🔑 Secure Sign-in/Sign-up** - JWT token-based authentication
- **👥 Role Management** - Customer and admin role support
- **📱 Guest Access** - Browse without account creation
- **🔒 Data Protection** - Secure local storage with Hive

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart (3.0 or higher)
- Firebase Account
- Stripe Account

## 🏗️ Project Structure

```
quick_slice/
├── 📁 android/                 # Android specific files
├── 📁 assets/                  # Images, icons, fonts
├── 📁 ios/                     # iOS specific files
├── 📁 lib/
│   ├── 📁 pages/               # App screens
│   │   ├── 📁 auth_pages/      # Authentication screens
│   │   ├── home_page.dart      # Main navigation
│   │   ├── product_list_page.dart
│   │   ├── cart_page.dart
│   │   ├── search_page.dart
│   │   ├── profile_page.dart
│   │   └── favourite_list_page.dart
│   ├── 📁 providers/           # State management
│   │   ├── user_provider.dart
│   │   └── cart_provider.dart
│   ├── 📁 services/            # Business logic
│   │   ├── auth_services.dart
│   │   └── stripe_service.dart
│   ├── 📁 widgets/             # Reusable components
│   │   ├── product_card.dart
│   │   ├── grid_view_builder.dart
│   │   └── custom_button.dart
│   └── main.dart               # App entry point
├── 📁 server/                  # Backend API
│   ├── 📁 models/
│   ├── 📁 routes/
│   ├── 📁 middleware/
│   └── index.js
└── pubspec.yaml               # Dependencies
```

## 🎨 UI Components

### Custom Widgets
- **ProductCard** - Beautiful food item cards with tags and favorites
- **GridViewBuilder** - Responsive grid layout for products
- **AppBarTitle** - Gradient styled app bar titles
- **CustomButton** - Reusable animated buttons
- **ExpandableTextInline** - Smart text expansion

### Navigation
- **CurvedNavigationBar** - Smooth bottom navigation
- **BottomSheetPage** - Customizable order options
- **Drawer Navigation** - Side menu for additional options

## 💳 Payment Integration

QuickSlice uses **Stripe** for secure payment processing:

```dart
// Example payment integration
await StripeService.instance.makePayment(
  amount: totalPrice,
  currency: 'usd',
);
```

**Features:**
- 💰 Real-time currency conversion (LKR to USD)
- 🔒 Secure payment processing
- 📱 Native payment sheet
- ✅ Success/failure handling

## 🔥 Firebase Integration

### Firestore Collections
- **products** - Menu items with categories
- **users** - User data and preferences

### Features
- 📊 Real-time data synchronization
- 🔄 Live favorites updates
- 🖼️ Cloud storage for images
- 📱 Cross-platform support

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Firebase** | Backend & Authentication |
| **Stripe** | Payment processing |
| **Hive** | Local database |
| **Provider** | State management |
| **HTTP** | API communication |
| **Shared Preferences** | Local storage |



## 🏆 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Firebase** - For robust backend services
- **Stripe** - For seamless payment integration
- **Curved Navigation Bar** - For beautiful UI components

## 📞 Support

Having trouble? Contact us or create an issue:

- 📧 Email: 2000ruwantha@gmail.com
- 🐛 [Bug Reports](https://github.com/01Ruwantha/quick_slice/issues)
- 💡 [Feature Requests](https://github.com/01Ruwantha/quick_slice/issues)

---

<div align="center">

**Made with ❤️ and ☕ by Ruwantha Madhushan**

*Slice the Wait, Savor the Taste with QuickSlice!*

</div>

---

