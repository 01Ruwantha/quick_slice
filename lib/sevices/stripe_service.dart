import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class StripeService {
  StripeService._privateConstructor();
  static final StripeService instance = StripeService._privateConstructor();

  // --- Main Payment Function ---
  Future<void> makePayment({
    required double amount,
    required String currency,
  }) async {
    try {
      // Convert LKR → USD (approx rate)
      double amountInUSD = amount / 330;
      int finalAmount = (amountInUSD * 100).toInt(); // Stripe uses cents

      String? paymentIntentClientSecret = await _createPaymentIntent(
        finalAmount,
        'usd',
      );

      if (paymentIntentClientSecret == null) {
        throw Exception("Failed to create payment intent.");
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: paymentIntentClientSecret,
          style: ThemeMode.dark,
          merchantDisplayName: "Ruwantha Madhushan",
        ),
      );

      await _processPayment();
    } catch (e) {
      if (kDebugMode) print("Error in makePayment: $e");
      rethrow;
    }
  }

  // --- Create Payment Intent ---
  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      Map<String, dynamic> data = {
        "amount": amount.toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: data,
        headers: {
          'Authorization': "Bearer ${dotenv.env['STRIPE_SECRET_KEY']}",
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body["client_secret"];
      } else {
        if (kDebugMode) print("Stripe error: ${response.body}");
        return null;
      }
    } catch (e) {
      if (kDebugMode) print("Error in _createPaymentIntent: $e");
      return null;
    }
  }

  // --- Process Payment Sheet ---
  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      if (kDebugMode) print("Error in _processPayment: $e");
      rethrow;
    }
  }
}
