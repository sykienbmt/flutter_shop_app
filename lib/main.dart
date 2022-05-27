import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ProductsProvider.dart';
import 'package:shop_app/providers/authProvider.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/screens/authScreen/auth_screen.dart';
import 'package:shop_app/screens/cartScreen/cartScreen.dart';
import 'package:shop_app/screens/editProductScreen/editProductScreen.dart';
import 'package:shop_app/screens/orderScreen/orderScreen.dart';
import 'package:shop_app/screens/productDetail/productDetail.dart';
import 'package:shop_app/screens/productManager/productManagetScreen.dart';
import 'package:shop_app/screens/productOverViewScreen/productOverViewScreen.dart';
import 'package:shop_app/screens/splashScreen/splash_screen.dart';

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
            create: (ctx) => AuthProvider(),
          ),
          // ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          //   create: (_) => ProductsProvider('', []),
          //   update: (ctx, auth, previousProducts) => ProductsProvider(
          //       auth.getToken!,
          //       previousProducts == null ? [] : previousProducts.items),
          // ),
          ChangeNotifierProvider(
            create: (ctx) => ProductsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => CartProvider(),
          ),
          // ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          //   create: (_) => OrdersProvider('', []),
          //   update: (ctx, auth, previousOrders) => OrdersProvider(
          //       auth.getToken!,
          //       previousOrders == null ? [] : previousOrders.getOrders),
          // ),
          ChangeNotifierProvider.value(
            value: OrdersProvider(),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return MaterialApp(
              title: "My Shop",
              theme: ThemeData(
                primaryColor: Colors.blue,
                accentColor: Colors.orange,
                fontFamily: "Lato",
              ),
              home: authProvider.isAuth
                  ? ProductOverViewScreen()
                  : FutureBuilder(
                      future: authProvider.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ?
                      SplashScreen():AuthScreen()),
              // initialRoute: '/',
              routes: {
                // '/': ((context) => (AuthScreen())),
                // '/': ((context) => (ProductOverViewScreen())),
                ProductDetail.routerName: (context) => (const ProductDetail()),
                CartScreen.routerName: (context) => (const CartScreen()),
                OrderScreen.routerName: (context) => (const OrderScreen()),
                ProductManagerScreen.routerName: (context) =>
                    const ProductManagerScreen(),
                EditProductScreen.routerName: (context) => const EditProductScreen(),
              },
            );
          },
        ));
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
