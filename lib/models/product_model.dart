import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/minor_screen/edit_product.dart';
import 'package:myapp/minor_screen/product_detail_screen.dart';
import 'package:myapp/provider/wish_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProducModel extends StatefulWidget {
  final dynamic products;
  const ProducModel({super.key, required this.products});

  @override
  State<ProducModel> createState() => _ProducModelState();
}

class _ProducModelState extends State<ProducModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['dicount'];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProduceDetailScreen(
                proList: widget.products,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Container(
                      constraints:
                          const BoxConstraints(minHeight: 100, maxWidth: 250),
                      child: Image(
                          image: NetworkImage(widget.products['proimages'][0])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.products['proname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '\$ ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.products['price'].toStringAsFixed(2),
                                    style: onSale != 0
                                        ? const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          )
                                        : const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  onSale != 0
                                      ? Text(
                                          ((1 -
                                                      (widget.products[
                                                              'dicount'] /
                                                          100)) *
                                                  widget.products['price'])
                                              .toStringAsFixed(2),
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : const Text('')
                                ],
                              ),
                              widget.products['sid'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditProduct(
                                                items: widget.products,
                                              ),
                                            ));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.red,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        var existingItemWishlish = context
                                            .read<Wish>()
                                            .getWishItems
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.products['proid']);
                                        existingItemWishlish != null
                                            ? context.read<Wish>().removeThis(
                                                widget.products['proid'])
                                            : context.read<Wish>().addWishItem(
                                                widget.products['proname'],
                                                onSale != 0
                                                    ? ((1 -
                                                            (widget.products[
                                                                    'dicount'] /
                                                                100)) *
                                                        widget
                                                            .products['price'])
                                                    : widget.products['price'],
                                                1,
                                                widget.products['instock'],
                                                widget.products['proimages'],
                                                widget.products['proid'],
                                                widget.products['sid']);
                                      },
                                      icon: context
                                                  .watch<Wish>()
                                                  .getWishItems
                                                  .firstWhereOrNull((product) =>
                                                      product.documentId ==
                                                      widget
                                                          .products['proid']) !=
                                              null
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 30,
                                            )
                                          : const Icon(
                                              Icons.favorite_outline_outlined,
                                              color: Colors.red,
                                              size: 30,
                                            ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
                    top: 20,
                    left: 0,
                    child: Container(
                      height: 30,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Text('Save ${onSale.toString()}%'),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  ),
          ],
        ),
      ),
    );
  }
}
