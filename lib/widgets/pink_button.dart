import 'package:flutter/material.dart';

class PinkButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const PinkButton({
    super.key,
    required this.label,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: Colors.pink.shade400, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width * width,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(label,style: const TextStyle(color: Colors.white),),
      ),
    );
  }
}
