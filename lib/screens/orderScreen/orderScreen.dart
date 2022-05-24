import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/screens/orderScreen/widgets/orderItemRender.dart';

class OrderScreen extends StatelessWidget {
  static const routerName ='/orders'; 
  const OrderScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders= Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: ListView.builder(itemBuilder: ((context, index) {
        return OrderItemRender(orders.getOrders[index]);
      }),itemCount: orders.getOrders.length,),
    );
  }
}