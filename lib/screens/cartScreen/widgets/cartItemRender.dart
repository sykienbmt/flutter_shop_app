import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cartProvider.dart';

class CartItemRender extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItemRender(this.id,this.productId, this.price, this.quantity, this.title,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        cartProvider.removeItemCart(productId);
      },
      confirmDismiss: (val){
        return showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you want to remove the item from the cart?"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: Text("Yes")),
            TextButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: Text("No"))
          ],
        ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: FittedBox(
                  child: Text(
                    '\$$price',
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
