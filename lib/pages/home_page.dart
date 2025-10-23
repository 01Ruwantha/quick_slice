import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_slice/pages/drawer_page.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:quick_slice/widgets/grid_view_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _filters = [
    'Pizzas',
    'Melts',
    'Rice & Pasta',
    'Appetizers',
    'Desserts',
    'Drinks',
  ];
  late String selectedFilter;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    selectedFilter = _filters[0];
  }

  Stream<List<Map<String, dynamic>>> _getGridItemsStream(String filter) {
    final listNameMap = {
      'Pizzas': 'pizzas',
      'Melts': 'melts',
      'Rice & Pasta': 'riceandpasta',
      'Appetizers': 'appetizers',
      'Desserts': 'desserts',
      'Drinks': 'drinks',
    };

    final listName = listNameMap[filter];

    return _firestore
        .collection('products')
        .where('list_name', isEqualTo: listName)
        .snapshots()
        .map((snapshot) {
          // Convert docs to a list of maps
          final allItems = snapshot.docs.map((doc) => doc.data()).toList();

          // Use a map to remove duplicates by title
          final uniqueItemsMap = {
            for (var item in allItems) item['title']: item,
          };

          // Return the unique items as a list
          return uniqueItemsMap.values.toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
    );

    return Scaffold(
      drawer: const Drawer(child: DrawerPage()),
      appBar: AppBar(
        title: const AppBarTitle(text: 'QuickSlice', textSize: 35),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 35),
            onPressed: () {
              Scaffold.of(context).openDrawer();
              //
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              showCursor: false,
              enableInteractiveSelection: false,
              // onTap: () => Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => const SearchPage()),
              // ),
              onTap: () {
                GoRouter.of(context).push("/search");
              },
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Search',
                border: border,
                focusedBorder: border,
                enabledBorder: border,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: selectedFilter == filter
                            ? const Color.fromRGBO(249, 168, 37, 0.75)
                            : const Color.fromRGBO(245, 247, 249, 1),
                        label: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: selectedFilter == filter
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getGridItemsStream(selectedFilter),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading products',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fastfood_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${selectedFilter.toLowerCase()} found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for new items!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final gridItems = snapshot.data!;
                  // Just return GridViewBuilder (no Expanded)
                  return GridViewBuilder(listname: gridItems);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
