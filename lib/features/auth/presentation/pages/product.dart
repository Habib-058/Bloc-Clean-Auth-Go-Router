import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  final String productId;
  const Product({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
      ),
      body: Center(
        child: Text(
          'This is the Product Page: $productId',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
