import 'package:flutter/material.dart';
import 'package:myapp/models/wish_model.dart';
// import 'package:myapp/provider/card_provider.dart';
// import 'package:myapp/provider/product_class.dart';
import 'package:myapp/provider/wish_provider.dart';
import 'package:myapp/widgets/alert_dialog.dart';
import 'package:myapp/widgets/appbar_widgets.dart';
import 'package:provider/provider.dart';
// import 'package:collection/collection.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
              centerTitle: true,
              title: const AppBaTitle(
                title: "Wishlist",
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: const AppBarBackButton(),
               actions:  [
               context.watch<Wish>().getWishItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDailaog.showDailaog(
                            context: context,
                            title: 'Clear Wish',
                            content: 'Are your sure to clear Wishlish ?',
                            tapNo: () {
                              Navigator.pop(context);
                            },
                            tapYes: () {
                              context.read<Wish>().clearWishLish();
                            });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
                    )
            ],
            
              ),
          body: context.watch<Wish>().getWishItems.isNotEmpty
              ? const WishItems()
              : const EmptyWishList(),
        ),
      ),
    );
  }
}

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your WishList Is Empty !",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
