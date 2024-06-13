import 'package:flutter/material.dart';
import 'package:myapp/minor_screen/search_screen.dart';


class FakeScreen extends StatelessWidget {
  const FakeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen(),));
      },
      child: Container(
        height: 35,
         decoration: BoxDecoration(
          border: Border.all(width: 1.4,color: Colors.yellow),
          borderRadius: BorderRadius.circular(25)
         ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
           const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
             child:  Row(
              children: [
                Icon(Icons.search,color: Colors.grey,),
                Text("What are you looking for ?",style: TextStyle(color: Colors.grey),),
              ],
             ),
           ),
           Container(
            height: 32,
            width: 72,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(25)
            ),
            child:  const Center( 
              child:Text("Search",style: TextStyle(color: Colors.grey,fontSize: 18),)), 
           ),
        ],
      ),
      ),
    );
  }
}