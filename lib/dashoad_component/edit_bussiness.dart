import 'package:flutter/material.dart';
import 'package:myapp/widgets/appbar_widgets.dart';

class Editbusiness extends StatelessWidget {
  const Editbusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBaTitle(
          title: "Editbusiness ",
        ),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
    );
  }
}
