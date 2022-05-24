import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/editProductScreen/editProductScreen.dart';

class ProductManagerItem extends StatelessWidget {
  final Product product; 
  const ProductManagerItem(this.product,{ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl),),
        title: Text(product.title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routerName);
              }, icon: Icon(Icons.edit),color: Colors.green,),
              IconButton(onPressed: (){}, icon: Icon(Icons.delete),color:Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}