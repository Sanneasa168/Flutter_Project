import 'package:flutter/material.dart';
import 'package:myapp/widgets/appbar_widgets.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  AppBaTitle( title: "Address" ),
        leading: const  AppBarBackButton(),
      ),
    );
  }
}