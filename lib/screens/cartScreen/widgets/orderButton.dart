import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cartProvider.dart';
import '../../../providers/ordersProvider.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  final CartProvider cartProvider;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartProvider.totalAmount <= 0 || isLoading)
          ? null
          : () async {
            setState(() {
              isLoading=true;
            });
              await Provider.of<OrdersProvider>(context,
                      listen: false)
                  .addOrder(
                widget.cartProvider.items.values.toList(),
                widget.cartProvider.totalAmount,
              );
              setState(() {
              isLoading=false;
            });
              widget.cartProvider.clear();
            },
      child: isLoading? const CircularProgressIndicator() :const Text("ORDER NOW"),
    );
  }
}