 
import 'package:flower_app/pages/checkout.dart';
import 'package:flower_app/provider/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsAndPrice extends StatelessWidget {
  const ProductsAndPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carttt = Provider.of<Cart>(context);
    return Row(
      children: [
        Stack(
          children: [
            Positioned(
              bottom: 24,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(211, 164, 255, 193),
                      shape: BoxShape.circle),
                  child: Text(
                    "${carttt.itemCount}",
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                  )),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckOut(),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            "\$ ${carttt.price}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
