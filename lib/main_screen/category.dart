import 'package:flutter/material.dart';
import 'package:myapp/categories/accessory_category.dart';
import 'package:myapp/categories/bags_category.dart';
import 'package:myapp/categories/beauty_category.dart';
import 'package:myapp/categories/electronecs_category.dart';
import 'package:myapp/categories/home_garden_category.dart';
import 'package:myapp/categories/kids_category.dart';
import 'package:myapp/categories/men_category.dart';
import 'package:myapp/categories/shoes_category.dart';
import 'package:myapp/categories/women_category.dart';
import 'package:myapp/widgets/fake_search.dart';

List<ItemData> items = [
  ItemData(label: "men"),
  ItemData(label: "women"),
  ItemData(label: "shoes"),
  ItemData(label: "bads"),
  ItemData(label: "elctonices"),
  ItemData(label: "accessaries"),
  ItemData(label: "home & garden"),
  ItemData(label: "kids"),
  ItemData(label: "beauty"),
];


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    
     for (var element in items) {
                element.isSelected = false;
              }
              setState(() {
                items[0].isSelected = true;
              });
    super.initState();
  }
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const FakeScreen(),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: sideNaviagor(size),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: cateView(size),
          )
        ],
      ),
    );
  }

  Widget sideNaviagor(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.2,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceInOut,
              );
            },
            child: Container(
              height: 100,
              color: items[index].isSelected == true
                  ? Colors.white
                  : Colors.grey.shade300,
              child: Center(
                child: Text(
                  items[index].label,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget cateView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (value) {
          for (var element in items) {
                element.isSelected = false;
              }
              setState(() {
                items[value].isSelected = true;
              });
        },
        children: const [
          MenCategory(),
          WomenCategory(),
          ShoesCategory(),
          BagsCategory(),
          ElectroniceCategory(),
          AccessoryCategory(),
          HomeAndGarenCategory(),
          KidsCategory(),
          BeautyCategory(),
         
          
        ],
      ),
    );
  }
}

class ItemData {
  String label;
  bool isSelected;

  ItemData({
    required this.label,
    this.isSelected = false,
  });
}
