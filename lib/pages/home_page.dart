import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:quick_slice/pages/cart_page.dart';
import 'package:quick_slice/pages/product_list_page.dart';
import 'package:quick_slice/pages/profile_page.dart';
import 'package:quick_slice/pages/search_page.dart';
import 'package:quick_slice/pages/favourite_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 2;

  // Instead of widgets, keep functions that build them
  final List<Widget Function()> pages = [
    () => CartPage(key: UniqueKey()),
    () => FavouriteListPage(key: UniqueKey()),
    () => ProductListPage(key: UniqueKey()),
    () => SearchPage(key: UniqueKey()),
    () => ProfilePage(key: UniqueKey()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // call the builder so it creates a NEW widget every time
        child: pages[currentPage](),
      ),
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(
          context,
        ).copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          animationDuration: const Duration(milliseconds: 300), // fixed typo
          backgroundColor: Colors.transparent,
          color: Color(0xFF880E4F),
          index: currentPage,
          height: 75,
          animationCurve: Curves.easeInOut,
          onTap: (value) => setState(() {
            currentPage = value;
          }),
          items: const [
            Icon(Icons.shopping_cart_rounded),
            Icon(Icons.favorite),
            Icon(Icons.home),
            Icon(Icons.search_rounded),
            Icon(Icons.person),
          ],
        ),
      ),
    );
  }
}



// body: IndexedStack(
//         index: currentPage,
//         children: pages,
//       ),



// bottomNavigationBar: BottomNavigationBar(
//         iconSize: 35,
//         unselectedFontSize: 0,
//         selectedFontSize: 0,
//         currentIndex: currentPage,
//         onTap: (value) {
//           setState(() {
//             currentPage = value;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart_rounded),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: '',
//           )
//         ],
//       ),