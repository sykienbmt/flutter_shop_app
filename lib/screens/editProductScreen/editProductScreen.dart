import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ProductsProvider.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routerName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var editProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var initValues = {
    'title': "",
    'description': "",
    'price': "",
    'imageUrl': ""
  };

  var isInit = true;
  var isLoading = false;

  @override
  void initState() {
    imageFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageFocusNode.removeListener(updateImageUrl);
    imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final routerProduct =
            ModalRoute.of(context)?.settings.arguments as Product;
        editProduct = routerProduct;
        // print(editProduct.id);
        initValues = {
          'title': editProduct.title,
          'description': editProduct.description,
          'price': editProduct.price.toString(),
          // 'imageUrl': editProduct.imageUrl
          'imageUrl': ""
        };
        _imageUrlController.text = editProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void updateImageUrl() {
    if (!imageFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
              (!_imageUrlController.text.startsWith('http') &&
                  !_imageUrlController.text.startsWith('https'))
          // ||
          // (!_imageUrlController.text.endsWith(".png") &&
          //     _imageUrlController.text.endsWith(".jpg") &&
          //     _imageUrlController.text.endsWith(".jpeg"))
          ) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      isLoading = true;
    });

    if (editProduct.id != '') {
      print("edit");
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(editProduct);
    } else {
      print('add');

      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(editProduct);
      } catch (e) {
        showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('An Error occurred !'),
                content: Text(e.toString()),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK !'),
                  ),
                ],
              );
            });
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print(editProduct.id);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        initialValue: initValues['title'],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please provide a value";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editProduct = Product(
                            title: value as String,
                            description: editProduct.description,
                            imageUrl: editProduct.imageUrl,
                            price: editProduct.price,
                            id: editProduct.id,
                            isFavorite: editProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        initialValue: initValues['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a price";
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return "Price must be greater than 0";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editProduct = Product(
                            title: editProduct.title,
                            description: editProduct.description,
                            imageUrl: editProduct.imageUrl,
                            price: double.parse(value as String),
                            id: editProduct.id,
                            isFavorite: editProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        initialValue: initValues['description'],
                        focusNode: descriptionFocusNode,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(imageFocusNode);
                        },
                        onSaved: (value) {
                          editProduct = Product(
                            title: editProduct.title,
                            description: value as String,
                            imageUrl: editProduct.imageUrl,
                            price: editProduct.price,
                            id: editProduct.id,
                            isFavorite: editProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a description";
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor)),
                            child: Container(
                              child: _imageUrlController.text.isEmpty
                                  ? Text("Enter a Url")
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: imageFocusNode,
                              controller: _imageUrlController,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                saveForm();
                              },
                              onSaved: (value) {
                                editProduct = Product(
                                  title: editProduct.title,
                                  description: editProduct.description,
                                  imageUrl: value as String,
                                  price: editProduct.price,
                                  id: editProduct.id,
                                  isFavorite: editProduct.isFavorite,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter a image URL";
                                }
                                if (value.length < 10) {
                                  return 'Should be at least 10 characters long.';
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "Pls enter a valid url";
                                }
                                // if (!value.endsWith(".png") &&
                                //     !value.endsWith(".jpg") &&
                                //     !value.endsWith(".jpeg")) {
                                //   return 'Pls enter a valid image url';
                                // }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
