# <p align="center"><img src="https://raw.githubusercontent.com/01Ruwantha/quick_slice/main/assets/icon/icon.png?raw=true" alt="App Logo" width="200"/></p><p align="center"><img src="https://github.com/01Ruwantha/quick_slice/blob/main/assets/images/branding.png?raw=true" alt="branding png" width="200"/></p> <p align="center">Your Ultimate Pizza & Food Delivery App</p>

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-CLI-orange.svg)](https://firebase.google.com)
[![Stripe](https://img.shields.io/badge/Stripe-Payments-635bff.svg)](https://stripe.com)

*A feature-rich food delivery app built with Flutter that brings your favorite pizzas and meals right to your doorstep!*

</div>

## 📹 Video
    
<p align="center">
  <img 
  src="https://github.com/01Ruwantha/quick_slice/blob/main/video/QuickSlice.gif?raw=true" 
  alt="App Demo" 
  width="150" 
  height="300"
/>
</p>

## 📱 Screenshots

<div align="center">

| Home Screen | Add To Cart Page | Cart |
|-------------|-----------------|------|
| <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/homePage.jpg?raw=true" alt="Home page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/addToCardPage.jpg?raw=true" alt="Home page" width="150" height="300"> |<img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/cartPage.jpg?raw=true" alt="Cart page" width="150" height="300"> |

| Search | Favorites | Profile |
|--------|-----------|---------|
| <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/searchPage.jpg?raw=true" alt="Search page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/favouritePage.jpg?raw=true" alt="Favorites page" width="150" height="300">| <img src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/profilePage.jpg?raw=true" alt="Profile page" width="150" height="300"> |

</div>

## ✨ Features

### 🎯 Core Features
- **🍕 Multi-Category Menu** - Pizzas, Melts, Rice & Pasta, Appetizers, Desserts, and Drinks
- **🔍 Smart Search** - Find your favorite dishes instantly
- **❤️ Favorites System** - Save and quickly access your loved items
- **🛒 Smart Cart** - Customize orders with crust, size, sauce, and portion options
- **💳 Secure Payments** - Integrated Stripe payment gateway with LKR to USD conversion
- **👤 User Profiles** - Personalized experience with profile pictures and gallery upload
- **🔑 Multiple Auth Options** - Email/password and Google Sign-In
- **👥 Guest Access** - Browse without account creation
- **📧 Automated Email System** - Order confirmations with detailed receipts sent to both customers and admin

### 🎨 User Experience
- **📱 Beautiful UI/UX** - Modern, intuitive interface with smooth animations
- **🎯 Curved Navigation** - Elegant bottom navigation bar
- **🏷️ Smart Tagging** - Popular and Limited Time tags for quick discovery
- **📖 Expandable Descriptions** - Read more about each item with inline expansion
- **🔄 Real-time Updates** - Live menu and favorite synchronization
- **📧 Order Confirmation** - Automated email receipts to customers and admin

### 🔐 Authentication & Security
- **🔑 Secure Sign-in/Sign-up** - JWT token-based authentication with bcrypt
- **👤 Role Management** - Customer and admin role support
- **📱 Guest Access** - Browse without account creation
- **🔒 Data Protection** - Secure local storage with Hive
- **🌐 Google Sign-In** - Seamless authentication with Firebase Auth

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart (3.0 or higher)
- Firebase Account
- Stripe Account
- Node.js (for backend server)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/01Ruwantha/quick_slice.git
   cd quick_slice
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   Create a `.env` file in the root directory:
   ```
   uri=your_backend_server_url
   STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
   STRIPE_SECRET_KEY=your_stripe_secret_key
   SENDER_EMAIL=your_email@gmail.com
   APP_PASSWORD=your_app_password
   ADMIN_EMAIL=admin_email@gmail.com
   ```

4. **Set up Firebase**
   - Create a Firebase project
   - Enable Authentication (Email/Password & Google)
   - Enable Firestore Database
   - Add your platform configurations

5. **Set up backend server**
   ```bash
   cd server
   npm install
   npm start
   ```

6. **Run the app**
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
│   │   │   ├── sign_in.dart
│   │   │   └── sign_up.dart
│   │   ├── home_page.dart
│   │   ├── product_list_page.dart
│   │   ├── cart_page.dart
│   │   ├── search_page.dart
│   │   ├── profile_page.dart
│   │   ├── favourite_list_page.dart
│   │   ├── bottom_navigation_page.dart
│   │   ├── bottom_sheet_page.dart
│   │   └── drawer_page.dart
│   ├── 📁 providers/           # State management
│   │   ├── user_provider.dart
│   │   └── cart_provider.dart
│   ├── 📁 services/            # Business logic
│   │   ├── auth_services.dart
│   │   ├── stripe_service.dart
│   │   └── google_auth.dart
│   ├── 📁 widgets/             # Reusable components
│   │   ├── product_card.dart
│   │   ├── grid_view_builder.dart
│   │   ├── custom_button.dart
│   │   ├── app_bar_title.dart
│   │   └── text_form_field_widget.dart
│   ├── 📁 models/              # Data models
│   │   └── app_user.dart
│   ├── 📁 router/              # Navigation
│   │   ├── router.dart
│   │   └── router_names.dart
│   ├── 📁 utils/               # Utilities
│   │   └── utils.dart
│   └── main.dart               # App entry point
├── 📁 server/                  # Backend API (Node.js/Express)
│   ├── 📁 models/
│   │   └── user.js
│   ├── 📁 routes/
│   │   └── auth.js
│   ├── 📁 middleware/
│   │   └── auth.js
│   └── index.js
└── pubspec.yaml               # Dependencies
```

## 🎨 UI Components

### Custom Widgets
- **ProductCard** - Beautiful food item cards with tags and favorites
- **GridViewBuilder** - Responsive grid layout for products
- **AppBarTitle** - Gradient styled app bar titles
- **CustomButton** - Reusable animated buttons
- **TextFormFieldWidget** - Consistent form input fields

### Navigation
- **GoRouter** - Declarative routing with protected routes
- **CurvedNavigationBar** - Smooth bottom navigation
- **BottomSheetPage** - Customizable order options
- **Drawer Navigation** - Side menu with developer details

## 💳 Payment Integration

QuickSlice uses **Stripe** for secure payment processing with automatic currency conversion:

```dart
// Payment processing with LKR to USD conversion
await StripeService.instance.makePayment(
  amount: totalPrice, // in LKR
  currency: 'usd', // automatically converted
);
```

**Features:**
- 💰 Real-time currency conversion (LKR to USD)
- 🔒 Secure payment processing with native payment sheet
- 📧 Automated email confirmations to customers and admin
- ✅ Success/failure handling with user feedback

## 📧 Email System Features

QuickSlice includes a comprehensive email notification system:

### Order Confirmation Emails
- **Customer Receipts** - Detailed order summaries with itemized billing
- **Admin Notifications** - Order alerts sent via BCC for business tracking
- **HTML Templates** - Professional, branded email formatting
- **Order Details** - Complete order information including:
  - Customer contact information
  - Itemized product list with quantities
  - Customization options (crust, size, sauce, portion)
  - Product images and descriptions
  - Total pricing and payment confirmation

### Technical Implementation
- **Gmail SMTP Integration** - Secure email delivery
- **Attachment Support** - Screenshot uploads for customer feedback
- **Error Handling** - Robust failure management with user notifications
- **Template System** - Consistent branding across all communications

## 🔥 Firebase Integration

### Firestore Collections
- **products** - Menu items with categories, prices, and favorites
- **users** - User data, preferences, and authentication

### Authentication
- **Email/Password** - Traditional sign-up/sign-in
- **Google Sign-In** - OAuth2 authentication
- **Guest Mode** - Temporary access without account

### Features
- 📊 Real-time data synchronization
- 🔄 Live favorites updates across devices
- 🖼️ Cloud storage for user profile images
- 📱 Cross-platform support

## 🛠️ Technologies Used

| Technology | Purpose | Version |
|------------|---------|---------|
| **Flutter** | Cross-platform UI framework | 3.9.2 |
| **Dart** | Programming language | 3.0+ |
| **Firebase** | Backend & Authentication | ^12.0.2 |
| **Stripe** | Payment processing | ^12.0.2 |
| **Hive** | Local database | ^2.2.3 |
| **Provider** | State management | ^6.1.5+1 |
| **GoRouter** | Navigation routing | ^16.2.5 |
| **HTTP** | API communication | ^1.5.0 |
| **Shared Preferences** | Local storage | ^2.5.3 |
| **Cloud Firestore** | Real-time database | ^6.0.2 |
| **Firebase Auth** | Authentication | ^6.1.1 |
| **Mailer** | Email services | ^6.5.0 |

## 🔧 Backend API

The app uses a Node.js/Express backend with MongoDB:

### Key Endpoints
- `POST /api/signup` - User registration
- `POST /api/signin` - User login
- `POST /tokenIsValid` - Token validation
- `GET /` - Get user data (protected)

### Features
- 🔐 JWT-based authentication
- 🔒 Password hashing with bcrypt
- ✅ Input validation and error handling
- 🗄️ MongoDB with Mongoose ODM

## 🚀 Deployment

### Building for Production

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

### Environment Setup
1. Configure Firebase for each platform
2. Set up Stripe keys in environment variables
3. Configure email service credentials
4. Deploy backend API to hosting service

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues, fork the repository, and create pull requests.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🏆 Acknowledgments

- **Flutter Team** - For the amazing cross-platform framework
- **Firebase** - For robust backend services and authentication
- **Stripe** - For seamless payment integration
- **Google** - For OAuth authentication services
- **Curved Navigation Bar** - For beautiful UI components

## 📞 Support

Having trouble? Contact us or create an issue:

- 📧 Email: [2000ruwantha@gmail.com](mailto:2000ruwantha@gmail.com)
- 🐛 [Bug Reports](https://github.com/01Ruwantha/quick_slice/issues)
- 💡 [Feature Requests](https://github.com/01Ruwantha/quick_slice/issues)
- 🔧 [Technical Support](https://github.com/01Ruwantha/quick_slice/issues)

---

<div align="center">
<p align="center">
  <img 
  src="https://github.com/01Ruwantha/quick_slice/blob/main/Screenshots/QuickSliceImg.png?raw=true" 
  alt="QuickSlice Post Image" 
  width="1080" 
  height="720"
/>
</p>

**Made with ❤️ and ☕ by Ruwantha Madhushan**

*Slice the Wait, Savor the Taste with QuickSlice!*

</div>

---
