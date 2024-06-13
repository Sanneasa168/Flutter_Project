import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:myapp/main_screen/cart.dart';
import 'package:myapp/minor_screen/visit_stores.dart';
import 'package:myapp/minor_screen/full_screen_view.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/provider/card_provider.dart';
import 'package:myapp/provider/wish_provider.dart';
import 'package:myapp/widgets/appbar_widgets.dart';
import 'package:myapp/widgets/snackbar.dart';
import 'package:myapp/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:badges/badges.dart' as badges;
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';

class ProduceDetailScreen extends StatefulWidget {
  final dynamic proList;
  const ProduceDetailScreen({
    super.key,
    required this.proList,
  });

  @override
  State<ProduceDetailScreen> createState() => _ProduceDetailScreenState();
}

class _ProduceDetailScreenState extends State<ProduceDetailScreen> {
  late final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.proList['maincateg'])
      .where('subcateg', isEqualTo: widget.proList['subcateg'])
      .snapshots();

  late final Stream<QuerySnapshot> reviewStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.proList['proid'])
      .collection('reviews')
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imageList = widget.proList['proimages'];

  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['dicount'];
    var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
        (product) => product.documentId == widget.proList['proid']);
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldkey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenView(
                              imageList: imageList,
                            ),
                          ));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              return Image(
                                  image: NetworkImage(imageList[index]));
                            },
                          ),
                        ),
                        Positioned(
                            left: 15,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.black,
                                ),
                              ),
                            )),
                        Positioned(
                            right: 15,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.black,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.proList['proname'],
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'USD ',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      widget.proList['price']
                                          .toStringAsFixed(2),
                                      style: onSale != 0
                                          ? const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            )
                                          : const TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    onSale != 0
                                        ? Text(
                                            ((1 -
                                                        (widget.proList[
                                                                'dicount'] /
                                                            100)) *
                                                    widget.proList['price'])
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
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  var existingItemWishlish = context
                                      .read<Wish>()
                                      .getWishItems
                                      .firstWhereOrNull((product) =>
                                          product.documentId ==
                                          widget.proList['proid']);
                                  existingItemWishlish != null
                                      ? context
                                          .read<Wish>()
                                          .removeThis(widget.proList['proid'])
                                      : context.read<Wish>().addWishItem(
                                          widget.proList['proname'],
                                          onSale != 0
                                              ? ((1 -
                                                      (widget.proList[
                                                              'dicount'] /
                                                          100)) *
                                                  widget.proList['price'])
                                              : widget.proList['price'],
                                          1,
                                          widget.proList['instock'],
                                          widget.proList['proimages'],
                                          widget.proList['proid'],
                                          widget.proList['sid']);
                                },
                                icon: context
                                            .watch<Wish>()
                                            .getWishItems
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.proList['proid']) !=
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
                      ),
                      widget.proList['instock'] == 0
                          ? const Text(
                              'this item is out of stock',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 16),
                            )
                          : Text(
                              (widget.proList['instock'].toString()) +
                                  ('pieces available in stock'),
                              style: const TextStyle(
                                  color: Colors.blueGrey, fontSize: 16),
                            ),
                    ],
                  ),
                  const ProDetailHeader(
                    label: "Items Description",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.proList['producs'],
                      textScaleFactor: 1.1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade800,
                      ),
                    ),
                  ),
                  const ProDetailHeader(
                    label: "Similar Items",
                  ),
                  Stack(
                    children: [
                      Positioned(top: 15, right: 50, child: Text('total')),
                      ExpandableTheme(
                          data: const ExpandableThemeData(
                              iconSize: 24, iconColor: Colors.blue),
                          child: reviews(reviewStream)),
                    ],
                  ),
                  SizedBox(
                    child: StreamBuilder(
                        stream: _productStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text(" Somthing Wrong ");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text(
                                "This Category \n\n has no items yet !",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: 'Acme',
                                ),
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            child: StaggeredGridView.countBuilder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ProducModel(
                                  products: snapshot.data!.docs[index],
                                );
                              },
                              staggeredTileBuilder: (context) =>
                                  const StaggeredTile.fit(1),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VisitStores(suppID: widget.proList['sid']),
                              ));
                        },
                        icon: const Icon(Icons.store)),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CardScreen(
                                        back: AppBarBackButton(),
                                      )));
                        },
                        icon: badges.Badge(
                            showBadge: context.read<Cart>().getItems.isEmpty
                                ? false
                                : true,
                            badgeContent: Text(context
                                .watch<Cart>()
                                .getItems
                                .length
                                .toString()),
                            child: const Icon(Icons.shopping_cart))),
                    YellowButton(
                        label: existingItemCart != null
                            ? 'added to cart  '
                            : 'ADD TO CART',
                        width: 0.55,
                        onPressed: () {
                          if (widget.proList['instock'] == 0) {
                            MyMessageHandler.showSnackBar(
                                _scaffoldkey, 'this item is out of  stock');
                          } else if (existingItemCart != null) {
                            MyMessageHandler.showSnackBar(
                                _scaffoldkey, 'this item already in cart');
                          } else {
                            context.read<Cart>().addItem(
                                widget.proList['proname'],
                                onSale != 0
                                    ? ((1 - (widget.proList['dicount'] / 100)) *
                                        widget.proList['price'])
                                    : widget.proList['price'],
                                1,
                                widget.proList['instock'],
                                widget.proList['proimages'],
                                widget.proList['proid'],
                                widget.proList['sid']);
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailHeader extends StatelessWidget {
  final String label;
  const ProDetailHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviews(var reviewStream) {
  return ExpandablePanel(
    header: const Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        "Reviews",
        style: TextStyle(
            color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    collapsed: SizedBox(
      height: 240,
      child: reviewAll(reviewStream),
    ),
    expanded: reviewAll(reviewStream),
  );
}

Widget reviewAll(var reviewStream) {
  return StreamBuilder(
      stream: reviewStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
        if (snapshot2.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot2.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "This Item \n\n has no reviews yet !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                // fontFamily: 'Acme',
              ),
            ),
          );
        }
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot2.data!.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(snapshot2.data!.docs[index]['profileimage']),
                ),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snapshot2.data!.docs[index]['name']),
                      Row(
                        children: [
                          Text(
                            snapshot2.data!.docs[index]['rate'].toString(),
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          )
                        ],
                      )
                    ]),
              );
            });
      });
}
