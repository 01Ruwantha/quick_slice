import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_slice/pages/bottom_sheet_page.dart';
import 'package:quick_slice/widgets/expandable_text_lnline%20.dart';
import 'package:quick_slice/widgets/limited_time_tag.dart';
import 'package:quick_slice/widgets/popular_tag.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  /// We no longer store a separate isLiked state, instead always use widget.product['favourite']
  bool get isLiked => widget.product['favourite'] == true;

  /// Toggle favourite for all products with the same title
  Future<void> toggleFavouriteForSameTitle() async {
    try {
      final newValue = !isLiked;

      // Update Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('title', isEqualTo: widget.product['title'])
          .get();

      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(doc.id)
            .update({'favourite': newValue});
      }

      // Optional: Trigger a rebuild so the UI reflects the new state immediately
      setState(() {
        widget.product['favourite'] = newValue;
      });

      if (kDebugMode) {
        print(
          'Firestore updated successfully for all products with title: ${widget.product['title']}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.product['imageUrl'] ?? '',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),

                    // Veg / Non-Veg dot
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: widget.product['type'] == 'Vegetarian'
                              ? Colors.green
                              : Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),

                    // Favourite icon (bottom-right)
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: toggleFavouriteForSameTitle,
                        child: Icon(
                          Icons.favorite,
                          size: 30,
                          color: isLiked ? Colors.red : Colors.white,
                        ),
                      ),
                    ),

                    // Popular Tag
                    if (widget.product['popular'] == true)
                      const Positioned(top: 0, left: 0, child: PopularTag()),

                    // Limited Time Tag
                    if (widget.product['limited_time'] == true)
                      const Positioned(
                        bottom: 25,
                        left: 0,
                        child: LimitedTimeTag(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Text(
                widget.product['title'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
              ),

              const SizedBox(height: 10),
              ExpandableTextInline(
                text: widget.product['details'] ?? '',
                textSize: 10,
                trimLength: 30,
              ),

              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 2),

              // Add to Cart Button
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) =>
                        BottomSheetPage(product: widget.product),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.greenAccent, Colors.cyanAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: const Text(
                      'Add to cart',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
