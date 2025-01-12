
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myapp/widgets/yellow_button.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, required this.order});

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rate;
  late String comment;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(widget.order['orderimage']),
                  ),
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order['ordername'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(('\$') +
                              (widget.order['orderprice'].toStringAsFixed(2))),
                          Text(('x ') + (widget.order['orderqty'].toString())),
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
          subtitle: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("See more.. "), Text('Delivery status')],
          ),
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order['deliverystatus'] == ['delivered']
                    ? Colors.brown.withOpacity(0.2)
                    : Colors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ('Name : ') + (widget.order['custname']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Phone No. : ') + (widget.order['phone']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Email Address : ') + (widget.order['email']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Address : ') + (widget.order['address']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Payment Status : '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          (widget.order['paymentstatus']),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Delivery Status : '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          (widget.order['deliverystatus']),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    widget.order['deliverystatus :'] == 'shipping'
                        ? Text(
                            ('Estimated Delivery Date : ') +
                                (DateFormat('yyy-MM-dd').format(widget
                                        .order['deliverystatus']
                                        .toDate()))
                                    .toString(),
                            style: const TextStyle(fontSize: 15),
                          )
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Material(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 150),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        RatingBar.builder(
                                            initialRating: 1,
                                            minRating: 1,
                                            allowHalfRating: true,
                                            itemBuilder: (context, _) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              );
                                            },
                                            onRatingUpdate: (value) {
                                              rate = value;
                                            }),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: "Enter your review",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.amber,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            comment = value;
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            YellowButton(
                                                label: "cancel",
                                                width: 0.3,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                }),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            YellowButton(
                                                label: "ok",
                                                width: 0.3,
                                                onPressed: () async {
                                                  CollectionReference collRef =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "products")
                                                          .doc(widget
                                                              .order["proid"])
                                                          .collection(
                                                              "reviews");

                                                  await collRef
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .set({
                                                    'name': widget
                                                        .order['custname'],
                                                    'email':
                                                        widget.order['email'],
                                                    'rate': rate,
                                                    'comment': comment,
                                                    'profileimage': widget
                                                        .order['profileimage']
                                                  }).whenComplete(() async {
                                                    FirebaseFirestore.instance
                                                        .runTransaction((transaction)async{
                                                          DocumentReference  documentReference = FirebaseFirestore.instance.collection("orders").doc(widget.order['orders']);
                                                          transaction.update(documentReference,{
                                                            'orderviews':true
                                                          });
                                                        });
                                                       
                                                  });
                                                   await Future.delayed(const Duration(microseconds: 100)).whenComplete((){
                                                     Navigator.pop(context);
                                                   });
                                                }),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text('Write Review'))
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == true
                        ? const Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                              Text(
                                "Review Added",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          )
                        : const Text('')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
