import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_slice/providers/cart_provider.dart';
import 'package:quick_slice/sevices/stripe_service.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;

    // --- Calculate total price in LKR ---
    double totalPrice = 0;
    for (var item in cart) {
      final price = (item['selectedPrice'] is num)
          ? item['selectedPrice'] as num
          : 0;
      final count = item['itemCount'] ?? 1;
      totalPrice += price * count;
    }

    return Scaffold(
      appBar: AppBar(title: const AppBarTitle(text: 'Cart Page', textSize: 25)),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty 💔',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
                // Cart items
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (_, index) {
                      final item = cart[index];
                      final name =
                          item['title']?.toString() ?? 'Unknown product';
                      final price = (item['selectedPrice'] is num)
                          ? (item['selectedPrice'] as num).toStringAsFixed(2)
                          : '0.00';
                      final itemCount = item['itemCount'] ?? 1;
                      final size = item['selectedSize']?.toString() ?? '';
                      final crust = item['selectedCrust']?.toString() ?? '';
                      final sauce = item['selectedSauce']?.toString() ?? '';
                      final portion =
                          item['selectedPriceKey']?.toString() ?? '';
                      final imageUrl = item['imageUrl']?.toString();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: imageUrl != null && imageUrl.isNotEmpty
                              ? Stack(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      left: 5,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: item['type'] == 'Vegetarian'
                                              ? Colors.green
                                              : Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const CircleAvatar(
                                  radius: 25,
                                  child: Icon(Icons.fastfood, size: 28),
                                ),
                          title: Text(name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rs:\t$price"),
                              if (crust.isNotEmpty) Text("Crust:\t$crust"),
                              if (size.isNotEmpty) Text("Size:\t$size"),
                              if (sauce.isNotEmpty) Text("Sauce:\t$sauce"),
                              if (portion.isNotEmpty)
                                Text("Portion:\t$portion"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  cartProvider.removeProduct(item);
                                },
                              ),
                              Text(
                                "$itemCount",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  cartProvider.addProduct(item);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total + Checkout button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Proceeding to Checkout..."),
                              ),
                            );

                            try {
                              await StripeService.instance.makePayment(
                                amount: totalPrice,
                                currency: 'usd',
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Payment Successful ✅"),
                                ),
                              );

                              // ✅ Clear cart and refresh UI
                              cartProvider.clearCart();
                              setState(() {});
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Payment failed ❌: $e")),
                              );
                            }
                          },
                          child: Text(
                            "Pay Rs.${totalPrice.toStringAsFixed(2)} (USD ≈ ${(totalPrice / 330).toStringAsFixed(2)})",
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
            ),
    );
  }
}
