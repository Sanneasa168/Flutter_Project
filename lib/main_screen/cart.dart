import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main_screen/place_order.dart';
import 'package:myapp/models/cart_model.dart';
import 'package:myapp/provider/card_provider.dart';
import 'package:myapp/widgets/alert_dialog.dart';
import 'package:myapp/widgets/appbar_widgets.dart';
// import 'package:myapp/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

class CardScreen extends StatefulWidget {
  final Widget? back;
  const CardScreen({super.key, this.back});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            centerTitle: true,
            title: const AppBaTitle(
              title: "Cart",
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: widget.back,
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDailaog.showDailaog(
                            context: context,
                            title: 'Clear Cart',
                            content: 'Are your sure to clear cart ?',
                            tapNo: () {
                              Navigator.pop(context);
                            },
                            tapYes: () {
                              context.read<Cart>().clearCart();
                            });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
                    )
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total:\$',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      total.toStringAsFixed(2),
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Material(
                //   child: YellowButton(
                //     width: 0.45,
                //     label: "CHECK OUT",
                //     onPressed: () {},
                //   ),
                // )
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: MaterialButton(onPressed: total == 0.0 ? null : () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) =>  const PlaceOrderScreen(),));
                  },
                  child: const Text("CHECK OUT") ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your Cart Is Empty !",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            borderRadius: BorderRadius.circular(25),
            color: Colors.lightBlueAccent,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              child: const Text(
                "countinue shopping",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getItems[index];
            return CartModel(
              product: product,
              cart: context.read<Cart>(),
            );
          });
    });
  }
}
