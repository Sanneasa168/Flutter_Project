import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main_screen/category.dart';
import 'package:myapp/main_screen/dashboad.dart';
import 'package:myapp/main_screen/home.dart';
import 'package:myapp/main_screen/stores.dart';
import 'package:myapp/main_screen/upload_product.dart';
// import 'package:myapp/models/supp_order_model.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({super.key});

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int _seletedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    CategoryScreen(),
    StoreScreen(),
    DashboadScreen(),
    UploadScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('deliverystatus', isEqualTo: 'preparing')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text(" Somthing Wrong ");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(child: CircularProgressIndicator()));
          }

          return Scaffold(
            body: _tabs[_seletedIndex],
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              currentIndex: _seletedIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "Search"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.store), label: "Store"),
                BottomNavigationBarItem(
                    icon: Badge(child: Icon(Icons.dashboard)),
                    label: "Dashboad"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.upload,
                    ),
                    label: "Upload")
              ],
              onTap: (index) {
                setState(() {
                  _seletedIndex = index;
                });
              },
            ),
          );
        });
  }
}
