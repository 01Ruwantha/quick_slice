import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:quick_slice/providers/cart_provider.dart';
import 'package:quick_slice/sevices/stripe_service.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isProcessing = false;

  Future<bool> isHasEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString("email");
      return email != null && email.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'phone': prefs.getString('phone'),
      'email': prefs.getString('email'),
      'address': prefs.getString('address'),
    };
  }

  /// ✅ Send full details email to both customer and admin
  Future<void> sendEmailToCustomer({
    required Map<String, String?> customer,
    required List<Map<String, dynamic>> cart,
    required double totalPrice,
  }) async {
    final String senderEmail = dotenv.env['SENDER_EMAIL'] ?? '';
    final String senderPassword = dotenv.env['APP_PASSWORD'] ?? '';
    final String adminEmail = dotenv.env['ADMIN_EMAIL'] ?? '';

    if (senderEmail.isEmpty || senderPassword.isEmpty) {
      debugPrint("❌ Missing email credentials in .env");
      return;
    }

    final smtpServer = gmail(senderEmail, senderPassword);

    // 🧾 Build the cart items table
    final StringBuffer itemsTable = StringBuffer();
    for (var item in cart) {
      final name = item['title'] ?? 'Unknown Item';
      final count = item['itemCount'] ?? 1;
      final price = (item['selectedPrice'] is num)
          ? item['selectedPrice'] as num
          : 0;
      final subtotal = price * count;
      final crust = item['selectedCrust'] ?? '-';
      final size = item['selectedSize'] ?? '-';
      final sauce = item['selectedSauce'] ?? '-';
      final imageUrl = item['imageUrl'] ?? '';

      // ✅ Detect 6Pcs or 12Pcs automatically
      String portion = 'Regular';
      if (item['price'] != null && item['price'] is Map<String, dynamic>) {
        final priceMap = item['price'] as Map<String, dynamic>;
        if (priceMap['12Pcs'] != null) {
          portion = '12Pcs';
        } else if (priceMap['6Pcs'] != null) {
          portion = '6Pcs';
        }
      }

      itemsTable.writeln('''
        <tr style="border-bottom:1px solid #eee;">
          <td style="padding:12px;">
            ${imageUrl.isNotEmpty ? '<img src="$imageUrl" alt="$name" width="70" height="70" style="border-radius:8px;object-fit:cover;margin-bottom:6px;">' : '<div style="width:70px;height:70px;border-radius:8px;background:#ddd;display:flex;align-items:center;justify-content:center;">🍕</div>'}
            <div style="font-size:16px;font-weight:bold;margin-top:6px;">$name</div>
            <div style="font-size:13px;color:#777;">Crust: $crust | Size: $size | Sauce: $sauce | Portion: $portion</div>
          </td>
          <td style="padding:12px;text-align:center;">$count</td>
          <td style="padding:12px;text-align:right;">Rs.${price.toStringAsFixed(2)}</td>
          <td style="padding:12px;text-align:right;font-weight:bold;">Rs.${subtotal.toStringAsFixed(2)}</td>
        </tr>
      ''');
    }

    final customerDetails =
        '''
      <p><strong>Name:</strong> ${customer['name'] ?? 'N/A'}<br>
      <strong>Email:</strong> ${customer['email'] ?? 'N/A'}<br>
      <strong>Phone:</strong> ${customer['phone'] ?? 'N/A'}<br>
      <strong>Address:</strong> ${customer['address'] ?? 'N/A'}</p>
    ''';

    final htmlBody =
        '''
    <html>
      <body style="font-family:Arial,sans-serif;background-color:#f7f7f7;padding:20px;">
        <table align="center" width="700" cellpadding="0" cellspacing="0" style="background-color:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 8px rgba(0,0,0,0.1);">
          <tr>
            <td style="background-color:#ff3b3b;padding:20px;text-align:center;color:white;font-size:24px;font-weight:bold;">
              🍕 QuickSlice Order Confirmation
            </td>
          </tr>

          <tr>
            <td style="padding:20px;">
              <p>Hi <strong>${customer['name'] ?? 'Customer'}</strong>,</p>
              <p>Thank you for your order! Below are your order and contact details:</p>
              $customerDetails

              <h3 style="margin-top:20px;">🧾 Order Summary</h3>
              <table width="100%" style="border-collapse:collapse;margin-top:10px;font-size:14px;">
                <tr style="background-color:#f2f2f2;text-align:left;">
                  <th style="padding:10px;">Item</th>
                  <th style="padding:10px;text-align:center;">Qty</th>
                  <th style="padding:10px;text-align:right;">Price</th>
                  <th style="padding:10px;text-align:right;">Subtotal</th>
                </tr>
                $itemsTable
                <tr style="background-color:#ffecec;">
                  <td colspan="3" style="padding:10px;text-align:right;font-weight:bold;">Total:</td>
                  <td style="padding:10px;text-align:right;font-weight:bold;color:#d32f2f;">Rs.${totalPrice.toStringAsFixed(2)}</td>
                </tr>
              </table>

              <p style="margin-top:25px;">We’ll start preparing your delicious pizza right away! 🍕</p>
              <p>Best regards,<br><strong>The QuickSlice Team</strong></p>
            </td>
          </tr>

          <tr>
            <td style="background-color:#222;color:#ccc;padding:10px;text-align:center;font-size:12px;">
              © ${DateTime.now().year} QuickSlice — All Rights Reserved
            </td>
          </tr>
        </table>
      </body>
    </html>
    ''';

    final message = Message()
      ..from = Address(senderEmail, 'QuickSlice Orders')
      ..recipients.add(customer['email'] ?? '')
      ..bccRecipients.add(adminEmail)
      ..subject = 'Your QuickSlice Order Confirmation 🍕'
      ..html = htmlBody;

    try {
      await send(message, smtpServer);
      debugPrint(
        "✅ Email sent to ${customer['email']} and admin ($adminEmail)",
      );
    } catch (e) {
      debugPrint("❌ Email sending failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;

    double totalPrice = 0;
    for (var item in cart) {
      final price = (item['selectedPrice'] is num)
          ? item['selectedPrice'] as num
          : 0;
      final count = item['itemCount'] ?? 1;
      totalPrice += price * count;
    }

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Cart Page', textSize: 35),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: cart.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty 💔',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : FutureBuilder<bool>(
                    future: isHasEmail(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final hasEmail = snapshot.data ?? false;
                      if (!hasEmail) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Please log in before checkout',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: cart.length,
                              itemBuilder: (_, index) {
                                final item = cart[index];
                                final name = item['title'] ?? 'Unknown';
                                final price = (item['selectedPrice'] is num)
                                    ? (item['selectedPrice'] as num)
                                          .toStringAsFixed(2)
                                    : '0.00';
                                final itemCount = item['itemCount'] ?? 1;
                                final imageUrl = item['imageUrl'] ?? '';

                                // ✅ Detect portion for cart view
                                String portion = 'Regular';
                                if (item['price'] != null &&
                                    item['price'] is Map<String, dynamic>) {
                                  final priceMap =
                                      item['price'] as Map<String, dynamic>;
                                  if (priceMap['12Pcs'] != null) {
                                    portion = '12Pcs';
                                  } else if (priceMap['6Pcs'] != null) {
                                    portion = '6Pcs';
                                  }
                                }

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading: imageUrl.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              imageUrl,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const CircleAvatar(
                                            radius: 25,
                                            child: Icon(
                                              Icons.fastfood,
                                              size: 28,
                                            ),
                                          ),
                                    title: Text(name),
                                    subtitle: Text(
                                      "Rs. $price x$itemCount\nPortion: $portion",
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                          onPressed: () =>
                                              cartProvider.removeProduct(item),
                                        ),
                                        Text(
                                          "$itemCount",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          onPressed: () =>
                                              cartProvider.addProduct(item),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // 💳 Checkout Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.black12),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Rs. ${totalPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: _isProcessing
                                        ? null
                                        : () async {
                                            setState(
                                              () => _isProcessing = true,
                                            );
                                            try {
                                              await StripeService.instance
                                                  .makePayment(
                                                    amount: totalPrice,
                                                    currency: 'usd',
                                                  );

                                              final user =
                                                  await getUserDetails();
                                              await sendEmailToCustomer(
                                                customer: user,
                                                cart: cart,
                                                totalPrice: totalPrice,
                                              );

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Payment Successful ✅",
                                                  ),
                                                ),
                                              );
                                              cartProvider.clearCart();
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Payment failed ❌: $e",
                                                  ),
                                                ),
                                              );
                                            } finally {
                                              setState(
                                                () => _isProcessing = false,
                                              );
                                            }
                                          },
                                    child: Text(
                                      _isProcessing
                                          ? "Processing Payment..."
                                          : "Pay Rs.${totalPrice.toStringAsFixed(2)} (USD ≈ ${(totalPrice / 330).toStringAsFixed(2)})",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // 🔄 Loading Overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      "Processing Payment...",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
