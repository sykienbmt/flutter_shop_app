import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routerName = '/edit-product';

  const EditProductScreen({ Key? key }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Center(child: Text("Edit Product Screen")),
      
    );
  }
}