import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main_screen/cart.dart';
import 'package:myapp/main_screen/category.dart';
import 'package:myapp/main_screen/home.dart';
import 'package:myapp/main_screen/profits.dart';
import 'package:myapp/main_screen/stores.dart';

class CustomeHome extends StatefulWidget {
  const CustomeHome({super.key});

  @override
  State<CustomeHome> createState() => _CostomeHomeState();
}

class _CostomeHomeState extends State<CustomeHome> {
     int _seletedIndex = 0;
    final List<Widget> _tabs =  [
      const HomeScreen(),
      const CategoryScreen(),
      const  StoreScreen(),
      const CardScreen(),
      ProfitsScreen(documentId: FirebaseAuth.instance.currentUser!.uid),
      // const ProfitsScreen(),
      
    ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _tabs[_seletedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        currentIndex: _seletedIndex,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.store),label: "Store"),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard_outlined),label: "Card"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance),label: "Accont")
        ],
        onTap: (index) {
          setState(() {
            _seletedIndex =index;
          });
        },
      ),
    );
  }
}