import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const YellowButton({
    super.key,
    required this.label,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration:  BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(25)
      ),
      width: MediaQuery.of(context).size.width * width,
      child: MaterialButton(
        onPressed:onPressed,
        child:  Text(label),
      ),
    );
  }
}
