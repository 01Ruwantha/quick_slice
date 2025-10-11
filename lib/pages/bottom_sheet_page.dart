import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_button.dart';

class BottomSheetPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const BottomSheetPage({super.key, required this.product});

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> {
  String? selectedCrust;
  String? selectedSize;
  String? selectedSauce;
  String? selectedPriceKey;

  Map<String, dynamic> crustMap = {};

  @override
  void initState() {
    super.initState();

    // --- CLEAN CRUST DATA ---
    final rawCrust = widget.product['crust'];
    crustMap = {};
    if (rawCrust is Map) {
      rawCrust.forEach((key, value) {
        if (key != null && value != null) {
          if (value is List) {
            crustMap[key.toString()] = value.whereType<String>().toList();
          } else {
            crustMap[key.toString()] = value;
          }
        }
      });
    }

    // --- CLEAN SAUCE DATA ---
    final sauceRaw = widget.product['Sauce'];
    List<String> sauceList = [];
    if (sauceRaw is List) {
      sauceList = sauceRaw.whereType<String>().toList();
    }

    // Preselect crust & size
    if (crustMap.isNotEmpty) {
      selectedCrust = crustMap.keys.first;
      final sizes = crustMap[selectedCrust];
      if (sizes is List && sizes.isNotEmpty) {
        selectedSize = sizes.first;
      }
    }

    // Preselect sauce
    if (sauceList.isNotEmpty) {
      selectedSauce = sauceList.first;
    }

    // Preselect price key if product has custom price keys and no crust/size/sauce
    final priceMap = widget.product['price'];
    if (priceMap is Map &&
        priceMap['price'] == null &&
        crustMap.isEmpty &&
        sauceList.isEmpty) {
      final availableKeys = priceMap.keys
          .where((key) => priceMap[key] != null)
          .toList(growable: false);
      if (availableKeys.isNotEmpty) {
        selectedPriceKey = availableKeys.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final crustOptions = crustMap.keys.toList();

    final sizeOptions = selectedCrust != null
        ? (crustMap[selectedCrust] is List
            ? (crustMap[selectedCrust] as List).cast<String>()
            : <String>[])
        : <String>[];

    final sauceRaw = widget.product['Sauce'];
    final sauceOptions =
        sauceRaw is List ? sauceRaw.whereType<String>().toList() : <String>[];

    final priceMap = widget.product['price'];

    // Determine price
    num price = 0;
    if (priceMap is Map) {
      if (selectedSize != null && priceMap[selectedSize] is num) {
        price = priceMap[selectedSize];
      } else if (selectedPriceKey != null &&
          priceMap[selectedPriceKey] is num) {
        price = priceMap[selectedPriceKey];
      } else if (priceMap['price'] is num) {
        price = priceMap['price'];
      }
    }

    // Only show portion selection if no crust, size, or sauce and 6Pcs,12Pcs not null
    final showPortionDropdown = crustOptions.isEmpty &&
        sizeOptions.isEmpty &&
        sauceOptions.isEmpty &&
        widget.product['price']['6Pcs'] != null &&
        widget.product['price']['12Pcs'] != null;

    final customPriceKeys = priceMap is Map
        ? priceMap.keys.where((key) => priceMap[key] != null).toList()
        : <String>[];

    return Container(
      padding: const EdgeInsets.all(16),
      height: double.infinity,
      child: Column(
        children: [
          /// Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Text(
                    widget.product['title'] ?? 'Custom Item',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),

                  /// Crust Dropdown
                  if (crustOptions.isNotEmpty) ...[
                    const Text('Select your crust',
                        style: TextStyle(fontSize: 18)),
                    DropdownButton<String>(
                      value: selectedCrust,
                      isExpanded: true,
                      items: crustOptions
                          .map((crust) => DropdownMenuItem(
                                value: crust,
                                child: Text(crust),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCrust = value;
                          final sizes = crustMap[selectedCrust];
                          if (sizes is List && sizes.isNotEmpty) {
                            selectedSize = sizes.first;
                          } else {
                            selectedSize = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  /// Size Dropdown
                  if (sizeOptions.isNotEmpty) ...[
                    const Text('Select Size', style: TextStyle(fontSize: 18)),
                    DropdownButton<String>(
                      value: selectedSize,
                      isExpanded: true,
                      items: sizeOptions.map((size) {
                        final sizePrice =
                            priceMap is Map ? priceMap[size] : null;
                        return DropdownMenuItem<String>(
                          value: size,
                          child: Text(
                              "$size - ${sizePrice != null ? (sizePrice as num).toStringAsFixed(2) : 'N/A'}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSize = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  /// Sauce Dropdown
                  if (sauceOptions.isNotEmpty) ...[
                    const Text('Select Sauce', style: TextStyle(fontSize: 18)),
                    DropdownButton<String>(
                      value: selectedSauce,
                      isExpanded: true,
                      items: sauceOptions
                          .map((sauce) => DropdownMenuItem(
                                value: sauce,
                                child: Text(sauce),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSauce = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  /// Portion Dropdown only if needed
                  if (showPortionDropdown && customPriceKeys.isNotEmpty) ...[
                    const Text('Select Portion',
                        style: TextStyle(fontSize: 18)),
                    DropdownButton<String>(
                      value: selectedPriceKey,
                      isExpanded: true,
                      items: customPriceKeys.map((key) {
                        final keyPrice = priceMap[key];
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(
                              "$key - Rs. ${keyPrice != null ? (keyPrice as num).toStringAsFixed(2) : 'N/A'}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriceKey = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),

          /// Add to Cart button
          SafeArea(
            child: Center(
              child: Column(children: [
                Text(
                  "Price: Rs. ${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const Divider(),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Add to Cart',
                  onTap: () {
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);

                    // --- CLEAN PRODUCT MAP FOR HIVE ---
                    final safeProduct =
                        Map<String, dynamic>.from(widget.product)
                          ..removeWhere(
                              (key, value) => value == null || value is Set);

                    safeProduct['selectedCrust'] = selectedCrust;
                    safeProduct['selectedSize'] = selectedSize;
                    safeProduct['selectedSauce'] = selectedSauce;
                    safeProduct['selectedPriceKey'] = selectedPriceKey;
                    safeProduct['selectedPrice'] = price;

                    cartProvider.addProduct(safeProduct);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item added to cart!')),
                    );

                    Navigator.pop(context);
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
