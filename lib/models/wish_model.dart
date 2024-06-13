import 'package:flutter/material.dart';
import 'package:myapp/provider/card_provider.dart';
import 'package:myapp/provider/product_class.dart';
import 'package:myapp/provider/wish_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WishItems extends StatelessWidget {
  const WishItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(builder: (context, wish, child) {
      return ListView.builder(
          itemCount: wish.count,
          itemBuilder: (context, index) {
            final product = wish.getWishItems[index];
            return WishListModel(product: product);
          });
    });
  }
}

class WishListModel extends StatelessWidget {
  const WishListModel({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Image.network(product.imagesUrl.first),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.price.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    context.read<Wish>().removeItem(product);
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  )),
                              context.watch<Cart>().getItems.firstWhereOrNull(
                                          (element) =>
                                              element.documentId ==
                                              product.documentId) !=
                                      null || product.qntty == 0
                                  ? const SizedBox()
                                  : IconButton(
                                      onPressed: () {
                                        context.read<Cart>().addItem(
                                              product.name,
                                              product.price,
                                              1,
                                              product.qntty,
                                              product.imagesUrl,
                                              product.documentId,
                                              product.suppId,
                                            );
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.black,
                                      )),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
