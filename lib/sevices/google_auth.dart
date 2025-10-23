import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- FIX: Add correct client IDs for each platform ---
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _getClientId(),
  );

  // Select correct client ID for each platform
  static String? _getClientId() {
    if (kIsWeb) {
      // Web client ID from Firebase
      return '1036021868367-34bj4271du0r3gd3sc2ujh2p0a6ba8t6.apps.googleusercontent.com';
    } else {
      // Android client ID from Firebase
      return '1036021868367-jhp5ks5q3km4cgkr27tqplgjo2h6g6eq.apps.googleusercontent.com';
    }
  }

  /// 🔹 Google Sign-In for Android/Web
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (kDebugMode) {
          print('⚠️ Google Sign-In canceled by user');
        }
        return null;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserData(user);
        if (kDebugMode) {
          print("✅ Google Sign-In Successful: ${user.displayName}");
        }
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Google Sign-In Error: $e');
      }
      rethrow;
    }
  }

  /// 🔹 Save user data to Firestore + local storage
  static Future<void> _saveUserData(User user) async {
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoURL': user.photoURL ?? '',
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Save locally with SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-auth-token', user.uid);
      await prefs.setString('name', user.displayName ?? '');
      await prefs.setString('email', user.email ?? '');
      await prefs.setString('photoURL', user.photoURL ?? '');
      await prefs.setString('role', 'user');
      await prefs.setString('provider', 'google');
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error saving user data: $e');
      }
    }
  }

  /// 🔹 Sign Out
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (kDebugMode) {
        print('👋 Signed out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error signing out: $e');
      }
    }
  }

  /// 🔹 Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
