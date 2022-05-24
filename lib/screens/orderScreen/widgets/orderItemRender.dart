import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/ordersProvider.dart';

class OrderItemRender extends StatefulWidget {
  final OrderItem order;

  const OrderItemRender(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItemRender> createState() => _OrderItemRenderState();
}

class _OrderItemRenderState extends State<OrderItemRender> {
  var isShowMore = false;

  @override
  Widget build(BuildContext context) {
    print(widget.order);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  isShowMore = !isShowMore;
                });
              },
              icon: isShowMore
                  ? Icon(Icons.expand_less)
                  : Icon(Icons.expand_more),
            ),
          ),
          if (isShowMore)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              height: min(widget.order.products.length * 15 + 20, 100),
              child: ListView(
                children: widget.order.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${product.quantity} x ${product.price}',
                              style:
                                  const TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
