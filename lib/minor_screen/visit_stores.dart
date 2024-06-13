import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/minor_screen/edit_store.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStores extends StatefulWidget {
  final String suppID;
  const VisitStores({
    super.key,
    required this.suppID,
  });

  @override
  State<VisitStores> createState() => _VisitStoresState();
}

class _VisitStoresState extends State<VisitStores> {
  bool following = false;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppID)
        .snapshots();
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
              child: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              flexibleSpace: data['coverimage'] =='' ?Image.asset(
                'assets/images/inapp/coverimage.jpg',
                fit: BoxFit.cover,
              ):Image.network(data['coverimage'],fit: BoxFit.cover,),
              leading: const YellowBackButton(),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.yellow),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data['storename'].toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.yellow),
                                ),
                              ),
                            ],
                          ),
                          data['sid'] == FirebaseAuth.instance.currentUser!.uid
                              ? Container(
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      border: Border.all(
                                          width: 3, color: Colors.black),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                         context,
                                         MaterialPageRoute(builder:(context) => EditStore(data:data)));
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("Edit"),
                                          Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          )
                                        ],
                                      )))
                              : Container(
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      border: Border.all(
                                          width: 3, color: Colors.black),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          following = !following;
                                        });
                                      },
                                      child: following == true
                                          ? const Text('following')
                                          : const Text('FOLLOW'))),
                        ]),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: _productStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text(" Somthing Wrong ");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Material(
                          child: Center(child: CircularProgressIndicator()));
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "This Store \n\n has no items yet !",
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
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {},
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }
        return const Text('Loading....');
      },
    );
  }
}
