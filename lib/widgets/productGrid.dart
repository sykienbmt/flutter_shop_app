import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ProductsProvider.dart';

import '../providers/product.dart';
import 'productItem.dart';

class ProductGrid extends StatelessWidget {
  final bool isShowFavorite;
  const ProductGrid(this.isShowFavorite, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        isShowFavorite ? productsData.showFavorite : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
            key: UniqueKey(),
          ),
        );
      },
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
