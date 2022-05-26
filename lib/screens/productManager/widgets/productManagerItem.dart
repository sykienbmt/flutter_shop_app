import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ProductsProvider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/editProductScreen/editProductScreen.dart';

class ProductManagerItem extends StatelessWidget {
  final Product product;
  const ProductManagerItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routerName,
                      arguments: product);
                },
                icon: Icon(Icons.edit),
                color: Colors.green,
              ),
              IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(product.id);
                    } catch (error) {
                      scaffold
                          .showSnackBar(SnackBar(content: Text("Delete Fail")));
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
