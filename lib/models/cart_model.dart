import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/provider/card_provider.dart';
import 'package:myapp/provider/product_class.dart';
import 'package:myapp/provider/wish_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    super.key,
    required this.product,
    required this.cart,
  });

  final Product product;
  final Cart cart;

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
                        children: [
                          Text(
                            product.price.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                product.qty == 1
                                    ? IconButton(
                                        onPressed: () {
                                          // cart.removeItem(product);
                                          showCupertinoModalPopup<void>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CupertinoActionSheet(
                                                    title: const Text(
                                                        "RemoveItems"),
                                                    message: const Text(
                                                        "Are you sure to remove this items ?"),
                                                    actions: <CupertinoActionSheetAction>[
                                                      CupertinoActionSheetAction(
                                                          onPressed: () {
                                                            context
                                                                        .read<
                                                                            Wish>()
                                                                        .getWishItems
                                                                        .firstWhereOrNull((element) =>
                                                                            element.documentId ==
                                                                            product
                                                                                .documentId) !=
                                                                    null
                                                                ? context
                                                                    .read<
                                                                        Cart>()
                                                                    .removeItem(
                                                                        product)
                                                                : context.read<Wish>().addWishItem(
                                                                    product
                                                                        .name,
                                                                    product
                                                                        .price,
                                                                    1,
                                                                    product
                                                                        .qntty,
                                                                    product
                                                                        .imagesUrl,
                                                                    product
                                                                        .documentId,
                                                                    product
                                                                        .suppId);

                                                            context
                                                                .read<Cart>()
                                                                .removeItem(
                                                                    product);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Move To Wishlist")),
                                                      CupertinoActionSheetAction(
                                                        onPressed: () async {
                                                          context
                                                              .read<Cart>()
                                                              .removeItem(
                                                                  product);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Delete Item"),
                                                      ),
                                                    ],
                                                    cancelButton: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.red),
                                                        )),
                                                  ));
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          size: 18,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          cart.reduceByOne(product);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.minus,
                                          size: 18,
                                        ),
                                      ),
                                Text(product.qty.toString(),
                                    style: product.qty == product.qntty
                                        ? const TextStyle(
                                            fontSize: 20, color: Colors.red)
                                        : const TextStyle(
                                            fontSize: 20,
                                          )),
                                IconButton(
                                  onPressed: product.qty == product.qntty
                                      ? null
                                      : () {
                                          cart.increment(product);
                                        },
                                  icon: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
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
