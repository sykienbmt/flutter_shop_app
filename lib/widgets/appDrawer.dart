import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/authProvider.dart';
import 'package:shop_app/screens/orderScreen/orderScreen.dart';
import 'package:shop_app/screens/productManager/productManagetScreen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("hello"),
            //disable back button
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title:Text("Shop"),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.online_prediction_rounded),
            title:Text("Orders"),
            onTap: (){
              Navigator.of(context).pushNamed(OrderScreen.routerName);
            },
          ),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title:Text("Product Manager"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ProductManagerScreen.routerName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title:const Text("Logout"),
            onTap: (){
              // Navigator.of(context).pop();
              // Navigator.of(context).pushNamed(ProductManagerScreen.routerName);
              Provider.of<AuthProvider>(context,listen: false).logout();
            },
          ),

        ],
      ),
    );
  }
}