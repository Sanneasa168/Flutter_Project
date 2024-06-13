
import 'package:flutter/material.dart';
import 'package:myapp/galleries/accessaries_gallery.dart';
import 'package:myapp/galleries/bags_gallery.dart';
import 'package:myapp/galleries/beauty_gallery.dart';
import 'package:myapp/galleries/electronics_gallery.dart';
import 'package:myapp/galleries/home_garden_gallery.dart';
import 'package:myapp/galleries/kids_gallery.dart';
import 'package:myapp/galleries/men_gallery.dart';
import 'package:myapp/galleries/shoes_gallery.dart';
import 'package:myapp/galleries/women_gallery.dart';
import 'package:myapp/widgets/fake_search.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade300.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const FakeScreen(),
          bottom:const TabBar(
            indicatorColor: Colors.yellow,
            isScrollable: true,
            tabs: [
            RepeatedTab(label: "Men",),
            RepeatedTab(label: "Women",),
            RepeatedTab(label: "Shoes",),
            RepeatedTab(label: "Bags",),
            RepeatedTab(label: "Eletronics",),
            RepeatedTab(label: "Accesories",),
            RepeatedTab(label: "Home & Garden",),
            RepeatedTab(label: "Kids",),
            RepeatedTab(label: "Beauty",), 
          ]
          ),
        ),
        body: const TabBarView(
          children: [
          MenGalleryScreen(),
          WomenGalleryScreen(),
          ShoesGalleryScreen(),
          BagsGalleryScreen(),
          ElectronicsGalleryScreen(),
          AccessaryGalleryScreen(),
          HomeAndGardenGalleryScreen(),
          KidsGalleryScreen(),
          BeautyGalleryScreen()
          
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({
     Key? key,
     required this.label,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
       label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
