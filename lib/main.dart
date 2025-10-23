import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quick_slice/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';

Future<void> main() async {
  // Initialize Flutter bindings
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve the splash screen until initialization is done
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Debug: Print all loaded environment variables
  if (kDebugMode) {
    print('Loaded environment variables:  ');
    print('uri: ${dotenv.env["uri"]}');
    print('STRIPE_PUBLISHABLE_KEY: ${dotenv.env["STRIPE_PUBLISHABLE_KEY"]}');
    print(
      'STRIPE_PUBLISHABLE_KEY length: ${dotenv.env["STRIPE_PUBLISHABLE_KEY"]?.length}',
    );
  }

  final stripeKey = dotenv.env["STRIPE_PUBLISHABLE_KEY"];
  if (stripeKey == null || stripeKey.isEmpty) {
    if (kDebugMode) {
      print('❌ Stripe key is null or empty');
    }
    throw Exception(
      "Stripe publishable key is missing or empty. Add STRIPE_PUBLISHABLE_KEY in your .env file.",
    );
  }

  if (kDebugMode) {
    print('✅ Stripe key found: ${stripeKey.substring(0, 20)}...');
  }
  Stripe.publishableKey = stripeKey;
  await Stripe.instance.applySettings();

  // Initialize Hive
  await Hive.initFlutter();
  if (!Hive.isBoxOpen('cartBox')) await Hive.openBox('cartBox');
  if (!Hive.isBoxOpen('profile')) await Hive.openBox('profile');

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Remove splash screen after initialization
  FlutterNativeSplash.remove();

  // Run app with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedToken = prefs.getString('x-auth-token') ?? '';

    setState(() {
      token = savedToken;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: token.isEmpty ? const SignIn() : const HomePage(),
      routerConfig: RouterClass().router,
    );
  }
}
