import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:quick_slice/widgets/grid_view_builder.dart';

class FavouriteListPage extends StatelessWidget {
  const FavouriteListPage({super.key});

  /// Stream of all unique favourite items
  Stream<List<Map<String, dynamic>>> _getAllFavouriteItemsStream() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('favourite', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final allItems = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // keep doc ID for updates
            return data;
          }).toList();

          // Remove duplicates based on title
          final uniqueItemsMap = {
            for (var item in allItems) item['title']: item,
          };

          return uniqueItemsMap.values.toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Favourite List', textSize: 25),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _getAllFavouriteItemsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favourites found 💔',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add some items to your favourite list!',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              final gridItems = snapshot.data!;
              return GridViewBuilder(listname: gridItems);
            },
          ),
        ),
      ),
    );
  }
}
