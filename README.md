# 🍕 QuickSlice - Your Ultimate Pizza & Food Delivery App

<div align="center">

![QuickSlice Banner](https://via.placeholder.com/800x200/880E4F/FFFFFF?text=QuickSlice+-+Slice+the+Wait,+Savor+the+Taste)

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-CLI-orange.svg)](https://firebase.google.com)
[![Stripe](https://img.shields.io/badge/Stripe-Payments-635bff.svg)](https://stripe.com)

*A feature-rich food delivery app built with Flutter that brings your favorite pizzas and meals right to your doorstep!*

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

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/quick_slice.git
   cd quick_slice
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   - Create a `.env` file in the root directory
   - Add your configuration:
     ```
     uri=your_backend_server_url
     STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
     STRIPE_SECRET_KEY=your_stripe_secret_key
     ```

4. **Firebase Setup**
   ```bash
   flutterfire configure
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

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

## 📱 Screenshots

<div align="center">

| Home Screen | Product Details | Cart |
|-------------|-----------------|------|
| ![Home](https://via.placeholder.com/200x400/880E4F/FFFFFF?text=Home) | ![Details](https://via.placeholder.com/200x400/E65100/FFFFFF?text=Details) | ![Cart](https://via.placeholder.com/200x400/F9A825/000000?text=Cart) |

| Search | Favorites | Profile |
|--------|-----------|---------|
| ![Search](https://via.placeholder.com/200x400/2196F3/FFFFFF?text=Search) | ![Favorites](https://via.placeholder.com/200x400/E91E63/FFFFFF?text=Favorites) | ![Profile](https://via.placeholder.com/200x400/4CAF50/FFFFFF?text=Profile) |

</div>

## 🚀 Getting Started for Developers

### Backend Setup
1. Navigate to the server directory:
   ```bash
   cd server
   npm install
   ```

2. Start the development server:
   ```bash
   npm run dev
   ```

### Environment Configuration
Create `lib/firebase_options.dart` using:
```bash
flutterfire configure
```

### Building for Production
```bash
flutter build apk --release
flutter build ios --release
```

## 🤝 Contributing

We love contributions! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏆 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Firebase** - For robust backend services
- **Stripe** - For seamless payment integration
- **Curved Navigation Bar** - For beautiful UI components

## 📞 Support

Having trouble? Contact us or create an issue:

- 📧 Email: support@quickslice.com
- 🐛 [Bug Reports](https://github.com/yourusername/quick_slice/issues)
- 💡 [Feature Requests](https://github.com/yourusername/quick_slice/issues)

---

<div align="center">

**Made with ❤️ and ☕ by Ruwantha Madhushan**

*Slice the Wait, Savor the Taste with QuickSlice!*

</div>

---

*Note: Replace placeholder images and links with actual screenshots and your repository URL before publishing.*
