
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/provider/card_provider.dart';
import 'package:myapp/widgets/appbar_widgets.dart';
import 'package:myapp/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CollectionReference customer =
      FirebaseFirestore.instance.collection('customer');

  void showProgress() {
    ProgressDialog progresss = ProgressDialog(context: context);
    progresss.show(
        max: 100, msg: 'Please wait...', progressBgColor: Colors.red);
  }

  int selectedValue = 1;
  late String orderId;
  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;
    return FutureBuilder(
        future: customer.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.hasData) {
            return const Text('Document does not exist');
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.grey.shade200,
                    leading: const AppBarBackButton(),
                    title: const AppBaTitle(title: 'Payment'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Total",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '${totalPaid.toStringAsFixed(2)} USD',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Total order",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} USD',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      "Shipping Coast",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '10.00 USD',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text("Cash On Dilivery"),
                                subtitle: const Text("Pay Cast At Home"),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text("Pay via visa /Master Card"),
                                subtitle: const Row(
                                  children: [
                                    Icon(
                                      Icons.payment,
                                      color: Colors.blue,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Icon(
                                        FontAwesomeIcons.ccMastercard,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.ccVisa,
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                              ),
                              RadioListTile(
                                  value: 3,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: const Text("Pay via Paypal"),
                                  subtitle: const Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.paypal,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccPaypal,
                                        color: Colors.blue,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                          label: 'Confim ${totalPaid.toStringAsFixed(2)},USA',
                          width: 1,
                          onPressed: () async {
                            if (selectedValue == 1) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 100),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                            'Pay At Home ${totalPaid.toStringAsFixed(2)}',
                                            style:
                                                const TextStyle(fontSize: 24)),
                                        YellowButton(
                                            label:
                                                'Confim ${totalPaid.toStringAsFixed(2)},USA',
                                            width: 1,
                                            onPressed: () async {
                                              showProgress();
                                              // ignore: use_build_context_synchronously
                                              for (var item in context
                                                  .read<Cart>()
                                                  .getItems) {
                                                CollectionReference orderRef =
                                                    FirebaseFirestore.instance
                                                        .collection('orders');
                                                orderId = const Uuid().v4();
                                                await orderRef
                                                    .doc(orderId)
                                                    .set({
                                                  'cid': data['cid'],
                                                  'custname': data['name'],
                                                  'email': data['address'],
                                                  'phone': data['phone'],
                                                  'profileimage':
                                                      data['profileimage'],
                                                  'sid': item.suppId,
                                                  'proid': item.documentId,
                                                  'orderid': orderId,
                                                  'ordername': item.name,
                                                  'orderimage':
                                                      item.imagesUrl.first,
                                                  'oderqty': item.qty,
                                                  'oderprice':
                                                      item.qty + item.price,
                                                  'deliverystatus': 'preparing',
                                                  'deliverdate': '',
                                                  'orderdate': DateTime.now(),
                                                  'paymentstatus ':
                                                      'cash on delivery',
                                                  'orderreview': false,
                                                }).whenComplete(() async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .runTransaction(
                                                          (transaction) async {
                                                    DocumentReference
                                                        documentReference =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'product')
                                                            .doc(item
                                                                .documentId);
                                                    DocumentSnapshot snapshot2 =
                                                        await transaction.get(
                                                            documentReference);
                                                    transaction.update(
                                                        documentReference, {
                                                      'instock':
                                                          snapshot2['instock'] -
                                                              item.qty
                                                    });
                                                  });
                                                });
                                              }
                                              // ignore: use_build_context_synchronously
                                              context.read<Cart>().clearCart();
                                              // ignore: use_build_context_synchronously
                                              await Future.delayed(
                                                      const Duration(
                                                      microseconds: 100))
                                                  .whenComplete(() {
                                                Navigator.popUntil(
                                                    context,
                                                    ModalRoute.withName(
                                                        '/customer_home'));
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (selectedValue == 2) {
                              
                              // int payment = totalPaid.round();
                              // int pay = payment * 100;
                              // await makePayment(data, pay.toString());
                            } else if (selectedValue == 3) {
                              // ignore: avoid_print
                              print('Paypa');
                            }
                          }),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
/*
  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment(dynamic data, String total) async {
    try {
      paymentIntentData = await createPaymentIntnet(total, "USD");
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_scret'],
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
              applePay:
                  const PaymentSheetApplePay(merchantCountryCode: 'ANIE')));
      await displayPaymentSheet(data);
    } catch (e) {
      // ignore: avoid_print
      print("Exception:$e");
    }
    // Create PaymentInternet
    //initPaymentSheet
    //dispayPaymentSheet
  }

  displayPaymentSheet(var data) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
        options:
            const PaymentSheetPresentOptions(timeout: int.fromEnvironment('0')),
      )
          .then((value) async {
        paymentIntentData = null;
        showProgress();
        // ignore: use_build_context_synchronously
        for (var item in context.read<Cart>().getItems) {
          CollectionReference orderRef =
              FirebaseFirestore.instance.collection('orders');
          orderId = const Uuid().v4();
          await orderRef.doc(orderId).set({
            'cid': data['cid'],
            'custname': data['name'],
            'email': data['address'],
            'phone': data['phone'],
            'profileimage': data['profileimage'],
            'sid': item.suppId,
            'proid': item.documentId,
            'orderid': orderId,
            'ordername': item.name,
            'orderimage': item.imagesUrl.first,
            'oderqty': item.qty,
            'oderprice': item.qty + item.price,
            'deliverystatus': 'preparing',
            'deliverdate': '',
            'orderdate': DateTime.now(),
            'paymentstatus ': 'paid online',
            'orderreview': false,
          }).whenComplete(() async {
            await FirebaseFirestore.instance
                .runTransaction((transaction) async {
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('product')
                  .doc(item.documentId);
              DocumentSnapshot snapshot2 =
                  await transaction.get(documentReference);
              transaction.update(documentReference,
                  {'instock': snapshot2['instock'] - item.qty});
            });
          });
        }
        // ignore: use_build_context_synchronously
        context.read<Cart>().clearCart();
        // ignore: use_build_context_synchronously
        await Future.delayed(const Duration(microseconds: 100))
            .whenComplete(() {
          Navigator.popUntil(context, ModalRoute.withName('/customer_home'));
        });
      });
      // ConfirmationResult
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  createPaymentIntnet(String total, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': total,
        'currency': currency,
        'payment_meyhod _types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeScretKey',
            'content_type': "application/x-www-form-urlencoded",
          });

      return jsonDecode(response.body);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
  */
}
