import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/screens/orderScreen/widgets/orderItemRender.dart';

class OrderScreen extends StatefulWidget {
  static const routerName = '/orders';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });

    if (isInit) {
      Provider.of<OrdersProvider>(context,listen: false)
          .fetchAndSetOrders()
          .then((value) => {});
    }

    setState(() {
      isLoading = false;
    });

    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: ((context, index) {
                return OrderItemRender(orders.getOrders[index]);
              }),
              itemCount: orders.getOrders.length,
            ),
    );
  }
}
