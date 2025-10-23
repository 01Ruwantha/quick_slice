import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_slice/pages/auth_pages/sign_in.dart';
import 'package:quick_slice/pages/auth_pages/sign_up.dart';
import 'package:quick_slice/pages/bottom_sheet_page.dart';
import 'package:quick_slice/pages/cart_page.dart';
import 'package:quick_slice/pages/favourite_list_page.dart';
import 'package:quick_slice/pages/bottom_navigation_page.dart';
import 'package:quick_slice/pages/home_page.dart';
import 'package:quick_slice/pages/profile_page.dart';
import 'package:quick_slice/pages/search_page.dart';
import 'package:quick_slice/router/router_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/signIn",
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: SafeArea(
            child: Center(child: Text("This page was not found!")),
          ),
        ),
      );
    },
    redirect: (context, state) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('x-auth-token') ?? '';
      bool isUserLoggedIn = token.isNotEmpty;

      // Check if user is guest (has guest token)
      bool isGuestUser = prefs.getBool('is_guest') ?? false;

      final isAuthRoute =
          state.matchedLocation == '/signIn' ||
          state.matchedLocation == '/signUp';

      // Allow access if user is logged in OR is guest
      bool hasAccess = isUserLoggedIn || isGuestUser;

      // If user doesn't have access and trying to access protected routes
      if (!hasAccess && !isAuthRoute) {
        return '/signIn';
      }

      // If user has access and trying to access auth routes, redirect to home
      if (hasAccess && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: "/",
        name: RouterNames.bottomNavigation,
        builder: (context, state) => const BottomNavigationPage(),
      ),
      GoRoute(
        path: "/signIn",
        name: RouterNames.signIn,
        builder: (context, state) => const SignIn(),
      ),
      GoRoute(
        path: "/signUp",
        name: RouterNames.signUp,
        builder: (context, state) => const SignUp(),
      ),
      // GoRoute(
      //   path: '/google-signin',
      //   name: RouterNames.googleSignIn,
      //   builder: (context, state) => const GoogleSignInPage(),
      // ),
      GoRoute(
        path: "/home",
        name: RouterNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: "/search",
        name: RouterNames.search,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: "/profile",
        name: RouterNames.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: "/favourite",
        name: RouterNames.favourite,
        builder: (context, state) => const FavouriteListPage(),
      ),
      GoRoute(
        path: "/cart",
        name: RouterNames.cart,
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: "/bottomSheet",
        name: RouterNames.bottomSheet,
        builder: (context, state) {
          final product = state.uri.queryParameters;
          return BottomSheetPage(product: product);
        },
      ),
    ],
  );
}
