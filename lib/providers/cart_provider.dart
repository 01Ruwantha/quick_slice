import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartProvider extends ChangeNotifier {
  final Box box = Hive.box('cartBox');

  // Get cart with proper typing
  List<Map<String, dynamic>> get cart {
    final storedCart = box.get('cart', defaultValue: []);
    return List<Map<String, dynamic>>.from(
        (storedCart as List).map((item) => Map<String, dynamic>.from(item)));
  }

  // Helper function to find index of a product variant
  int _findProductIndex(Map<String, dynamic> product) {
    return cart.indexWhere((item) =>
        item['title'] == product['title'] &&
        item['selectedCrust'] == product['selectedCrust'] &&
        item['selectedSize'] == product['selectedSize'] &&
        item['selectedSauce'] == product['selectedSauce'] &&
        item['selectedPriceKey'] == product['selectedPriceKey']);
  }

  // Add product to cart
  void addProduct(Map<String, dynamic> product) {
    final currentCart = cart;
    final index = _findProductIndex(product);

    if (index != -1) {
      // Product variant already exists, increment itemCount
      final existingProduct = currentCart[index];
      final currentCount = existingProduct['itemCount'] ?? 1;
      existingProduct['itemCount'] = currentCount + 1;
      currentCart[index] = existingProduct;
    } else {
      // First time adding this variant
      final newProduct = Map<String, dynamic>.from(product);
      newProduct['itemCount'] = 1;
      currentCart.add(newProduct);
    }

    box.put('cart', currentCart);
    notifyListeners();
  }

  // Remove product from cart
  void removeProduct(Map<String, dynamic> product) {
    final currentCart = cart;
    final index = _findProductIndex(product);

    if (index != -1) {
      final existingProduct = currentCart[index];
      final count = existingProduct['itemCount'] ?? 1;

      if (count > 1) {
        // Decrease itemCount
        existingProduct['itemCount'] = count - 1;
        currentCart[index] = existingProduct;
      } else {
        // Remove entirely if itemCount is 1
        currentCart.removeAt(index);
      }

      box.put('cart', currentCart);
      notifyListeners();
    }
  }

  // Clear entire cart
  void clearCart() {
    box.put('cart', []);
    notifyListeners();
  }
}
