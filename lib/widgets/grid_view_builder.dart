import 'package:flutter/material.dart';
import 'package:quick_slice/widgets/product_card.dart';

class GridViewBuilder extends StatefulWidget {
  final List<Map<String, dynamic>> listname;
  const GridViewBuilder({super.key, required this.listname});

  @override
  State<GridViewBuilder> createState() => _GridViewBuilderState();
}

class _GridViewBuilderState extends State<GridViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.5,
      ),
      itemCount: widget.listname.length,
      itemBuilder: (context, index) {
        final filter = widget.listname[index];
        return ProductCard(product: filter);
      },
    );
  }
}
