import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ProductsProvider.dart';
import 'package:shop_app/screens/editProductScreen/editProductScreen.dart';
import 'package:shop_app/screens/productManager/widgets/productManagerItem.dart';
import 'package:shop_app/widgets/appDrawer.dart';

class ProductManagerScreen extends StatelessWidget {
  static const routerName = '/manager';

  const ProductManagerScreen({Key? key}) : super(key: key);

  Future<void> refreshProductData(BuildContext context) async{
    await Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product manager"),
        actions: [IconButton(onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routerName);
        }, icon: Icon(Icons.add))],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh:(() =>  refreshProductData(context)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: ((context, index) {
              return ProductManagerItem(productsData.items[index]);
            }),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
