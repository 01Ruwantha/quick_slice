import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';
import '../pages/auth_pages/sign_in.dart';
import '../pages/home_page.dart';
import '../providers/user_provider.dart';

class AuthServices {
  // Sign Up
  Future<void> signUpUser({
    required BuildContext context,
    required String name,
    required String phone,
    required String email,
    required String role,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        phone: phone,
        email: email,
        role: role,
        token: '',
        password: password,
      );

      http.Response res = await http.post(
        Uri.parse('${dotenv.env['uri']}/api/signup'),
        body: user.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      _handleAuthResponse(
        response: res,
        context: context,
        onSuccess: () {
          _showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      _showSnackBar(context, e.toString());
      if (kDebugMode) debugPrint("SignUp Error: $e");
    }
  }

  // Sign In
  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      http.Response res = await http.post(
        Uri.parse('${dotenv.env['uri']}/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      _handleAuthResponse(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userProvider.setUser(res.body);

          final data = jsonDecode(res.body);
          await prefs.setString('x-auth-token', data['token'] ?? '');
          await prefs.setString('name', data['name'] ?? '');
          await prefs.setString('phone', data['phone'] ?? '');
          await prefs.setString('email', data['email'] ?? '');
          await prefs.setString('role', data['role'] ?? '');

          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      _showSnackBar(context, e.toString());
      if (kDebugMode) debugPrint("SignIn Error: $e");
    }
  }

  // Get User Data - COMPLETELY FIXED VERSION (No UI calls at all)
  Future<void> getUserData(BuildContext context) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('x-auth-token') ?? '';

      if (token.isEmpty) {
        if (kDebugMode) print("No token found, skipping getUserData");
        return;
      }

      if (kDebugMode) print("Validating token...");

      var tokenRes = await http.post(
        Uri.parse('${dotenv.env['uri']}/tokenIsValid'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (tokenRes.statusCode == 200) {
        final responseBody = tokenRes.body;
        if (responseBody.isNotEmpty) {
          try {
            final isValid = jsonDecode(responseBody);
            if (isValid == true) {
              if (kDebugMode) print("Token valid, fetching user data...");

              http.Response userRes = await http.get(
                Uri.parse('${dotenv.env['uri']}/'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'x-auth-token': token,
                },
              );

              if (userRes.statusCode == 200 && userRes.body.isNotEmpty) {
                userProvider.setUser(userRes.body);
                if (kDebugMode) print("User data loaded successfully");
              } else {
                if (kDebugMode)
                  print("Failed to load user data: ${userRes.statusCode}");
                await _clearUserData(prefs);
              }
            } else {
              if (kDebugMode) print("Token invalid");
              await _clearUserData(prefs);
            }
          } catch (e) {
            if (kDebugMode) print("JSON decode error: $e");
            await _clearUserData(prefs);
          }
        } else {
          if (kDebugMode) print("Empty response body");
          await _clearUserData(prefs);
        }
      } else {
        if (kDebugMode)
          print("Token validation failed: ${tokenRes.statusCode}");
        await _clearUserData(prefs);
      }
    } catch (e) {
      // Only log the error, don't show any UI
      if (kDebugMode) print("GetUserData Error: $e");
    }
  }

  // Helper method to clear user data
  Future<void> _clearUserData(SharedPreferences prefs) async {
    await prefs.remove('x-auth-token');
    await prefs.remove('name');
    await prefs.remove('phone');
    await prefs.remove('email');
    await prefs.remove('role');
    if (kDebugMode) print("Cleared user data due to invalid token");
  }

  // Sign Out
  Future<void> signOut(BuildContext context) async {
    try {
      final navigator = Navigator.of(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear SharedPreferences
      await prefs.clear();

      // Clear Hive Boxes
      await Hive.box('cartBox').clear();
      await Hive.box('profile').clear();

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignIn()),
        (route) => false,
      );
    } catch (e) {
      _showSnackBar(context, e.toString());
      if (kDebugMode) debugPrint("SignOut Error: $e");
    }
  }

  // Safe snackbar method that checks context
  void _showSnackBar(BuildContext context, String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
      }
    });
  }

  // Handle auth response without external utils dependency
  void _handleAuthResponse({
    required http.Response response,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) {
    switch (response.statusCode) {
      case 200:
        onSuccess();
        break;
      case 400:
        _showSnackBar(
          context,
          jsonDecode(response.body)['msg'] ?? 'Bad Request',
        );
        break;
      case 500:
        _showSnackBar(
          context,
          jsonDecode(response.body)['error'] ?? 'Server Error',
        );
        break;
      default:
        _showSnackBar(
          context,
          response.body.isNotEmpty ? response.body : 'Unknown error occurred',
        );
    }
  }
}
