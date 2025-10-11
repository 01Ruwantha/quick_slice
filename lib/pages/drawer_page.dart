import 'package:flutter/material.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.white,
          child: Center(child: AppBarTitle(text: 'QuickSlice', textSize: 35)),
        ),
        Container(
          width: double.infinity,
          height: double.minPositive,
          color: Colors.black,
          child: Center(child: AppBarTitle(text: 'QuickSlice', textSize: 35)),
        ),
      ],
    );
  }
}
