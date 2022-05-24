import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ProductsProvider.dart';
import 'package:shop_app/screens/productManager/widgets/productManagerItem.dart';
import 'package:shop_app/widgets/appDrawer.dart';

class ProductManagerScreen extends StatefulWidget {
  static const routerName = '/manager';

  const ProductManagerScreen({Key? key}) : super(key: key);

  @override
  State<ProductManagerScreen> createState() => _ProductManagerScreenState();
}

class _ProductManagerScreenState extends State<ProductManagerScreen> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product manager"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: ((context, index) {
            return ProductManagerItem(productsData.items[index]);
          }),
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}
