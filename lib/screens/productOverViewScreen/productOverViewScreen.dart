import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ProductsProvider.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/cartScreen/cartScreen.dart';
import 'package:shop_app/widgets/appDrawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/productGrid.dart';
import 'package:shop_app/widgets/productItem.dart';

enum ProductFilter { All, Favorites }

class ProductOverViewScreen extends StatefulWidget {
  ProductOverViewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var isShowFavorites = false;
  var isInit = true;
  var isLoading = false;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then(
  //       (_) => {Provider.of<ProductsProvider>(context).fetchAndSetProducts()});
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts()
          .then((value) => {
                setState(() {
                  isLoading = false;
                }),
              });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderData = Provider.of<CartProvider>(context);
    print(isLoading);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          PopupMenuButton(
            onSelected: (ProductFilter selectedValue) => {
              setState(() {
                if (selectedValue == ProductFilter.Favorites) {
                  isShowFavorites = true;
                } else {
                  isShowFavorites = false;
                }
              })
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: ((context) => [
                  const PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: ProductFilter.Favorites,
                  ),
                  const PopupMenuItem(
                    child: Text('Show All'),
                    value: ProductFilter.All,
                  ),
                ]),
          ),
          Badge(
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routerName);
                }),
            cartProviderData.getCountItemsCart.toString(),
            Colors.red,
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(isShowFavorites),
    );
  }
}
