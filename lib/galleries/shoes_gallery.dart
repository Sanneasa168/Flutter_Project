import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ShoesGalleryScreen extends StatefulWidget {
  const ShoesGalleryScreen ({super.key});

  @override
  State<ShoesGalleryScreen> createState() => _ShoesGalleryScreenState();
}

class _ShoesGalleryScreenState extends State<ShoesGalleryScreen> {
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: 'shoes')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text(" Somthing Wrong ");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:  CircularProgressIndicator()
            );
          }
          if(snapshot.data!.docs.isEmpty){
            return const Center(
              child: Text(
                "This Category \n\n has no items yet !",
                textAlign:TextAlign.center,
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
                return  ProducModel(products: snapshot.data!.docs[index],);
              },
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
            ),
          );
        });
  }
}
