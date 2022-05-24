import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/ProductsProvider.dart';

class ProductDetail extends StatelessWidget {
  static const routerName = '/product-detail';
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final loaderProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(loaderProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loaderProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loaderProduct.price}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Text(
                loaderProduct.description,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
