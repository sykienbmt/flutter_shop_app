import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ProductsProvider.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/screens/cartScreen/cartScreen.dart';
import 'package:shop_app/screens/editProductScreen/editProductScreen.dart';
import 'package:shop_app/screens/orderScreen/orderScreen.dart';
import 'package:shop_app/screens/productDetail/productDetail.dart';
import 'package:shop_app/screens/productManager/productManagetScreen.dart';
import 'package:shop_app/screens/productOverViewScreen/productOverViewScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        title: "My Shop",
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.orange,
          fontFamily: "Lato",
        ),
        // home: ProductOverViewScreen(),
        initialRoute: '/',
        routes: {
          '/': ((context) => (ProductOverViewScreen())),
          ProductDetail.routerName: (context) => (ProductDetail()),
          CartScreen.routerName: (context) => (CartScreen()),
          OrderScreen.routerName: (context) => (OrderScreen()),
          ProductManagerScreen.routerName:(context) => ProductManagerScreen(),
          EditProductScreen.routerName:(context)=>EditProductScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text("Shop App"),
      ),
    );
  }
}
