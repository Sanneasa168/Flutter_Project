import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/uitilities/categ_list.dart';
import 'package:myapp/widgets/categ_widgets.dart';

class ShoesCategory extends StatelessWidget {
  const ShoesCategory({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategHerderLabel(hearderlabel: 'Shoes'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children: List.generate(shoes.length - 1, (index) {
                        return CategSubModel(
                          mainCatgName: 'shoes',
                          subCateName: shoes[index + 1],
                          assetsName: 'assets/images/shoes/shoes$index.jpg',
                          subCategLabel: shoes[index + 1],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              mainCategName: 'shoes',
            ),
          )
        ],
      ),
    );
  }
}
