import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/authProvider.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/productDetail/productDetail.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<Product>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);


    final snackBar = SnackBar(
      content: const Text('Add to Cart done!'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(label: 'Undo', onPressed: (){
        cartProvider.removeSingleItem(product.id);
      },),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetail.routerName, arguments: product);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(product.isFavorite? Icons.favorite: Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.changeStatus(authProvider.getToken!);
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon:Icon(Icons.card_travel),
            color: Theme.of(context).accentColor,
            onPressed: (){
              cartProvider.addItemToCart(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ),
      ),
    );
  }
}
