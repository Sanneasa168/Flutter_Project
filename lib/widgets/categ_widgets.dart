import 'package:flutter/material.dart';
import 'package:myapp/minor_screen/subcategory_produce.dart';


class SliderBar extends StatelessWidget {
  final String mainCategName;
  const SliderBar({
    super.key,
    required this.mainCategName
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              const Text(
                '<<',
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 10
                  ),
              ),
                Text(
                mainCategName.toUpperCase(),
                style: const  TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
              ),
               const Text(
                '>>',
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 10
                  ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class CategSubModel extends StatelessWidget {
  final  String  mainCatgName;
  final String  subCateName;
  final String  assetsName;
  final String  subCategLabel;
  const CategSubModel({
    super.key,
    required this.mainCatgName,
    required this.subCateName,
    required this.assetsName,
    required this.subCategLabel
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCatesProducts(
                  subcategName: subCateName,
                  maincategName: mainCatgName,
              ),
            ));
      },
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Image(
                image: AssetImage(assetsName)),
          ),
          Text(subCategLabel,style: const TextStyle(fontSize: 11),)
        ],
      ),
    );
  }
}

class CategHerderLabel extends StatelessWidget {
  final String  hearderlabel;
  const CategHerderLabel({
    super.key,
    required this.hearderlabel
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          hearderlabel,
          style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              wordSpacing: 1.5),
        ));
  }
}
