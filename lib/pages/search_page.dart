import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:quick_slice/widgets/grid_view_builder.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Map<String, dynamic>>> _searchFuture;
  List<Map<String, dynamic>> _allItems = []; // All items from Future
  List<Map<String, dynamic>> _filteredItems = []; // Filtered items for search
  final TextEditingController _searchController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _searchFuture = populateSearchList();
    _searchFuture.then((data) {
      if (!mounted) return; // widget disposed
      setState(() {
        _allItems = data;
        _filteredItems = data; // show all initially
      });
    });
  }

  Future<List<Map<String, dynamic>>> populateSearchList() async {
    // Get all products from Firestore
    final snapshot = await _firestore.collection('products').get();

    // Convert docs to list of maps
    final allItems = snapshot.docs.map((doc) => doc.data()).toList();

    // Remove duplicates by title
    final uniqueItemsMap = {for (var item in allItems) item['title']: item};

    // Return unique items as a list
    return uniqueItemsMap.values.toList();
  }

  // Search function
  void _runSearch(String query) {
    if (_allItems.isEmpty) return;

    if (query.isEmpty) {
      setState(() {
        _filteredItems = _allItems;
      });
    } else {
      setState(() {
        _filteredItems = _allItems
            .where(
              (item) => item['title'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(text: 'Search Page', textSize: 35),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              hintText: 'Search',
              backgroundColor: WidgetStateProperty.all(Colors.white),
              elevation: WidgetStateProperty.all(0),
              onChanged: _runSearch,
            ),
            FutureBuilder(
              future: _searchFuture,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: GridViewBuilder(listname: _filteredItems),
                    );
                  }
                }
                return const Center(child: LinearProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
