import 'package:flutter/material.dart';
import 'package:myapp/dashoad_component/delivered_order.dart';
import 'package:myapp/dashoad_component/preparing_order.dart';
import 'package:myapp/dashoad_component/shipping_order.dart';
import 'package:myapp/widgets/appbar_widgets.dart';

class SuppierOrder extends StatelessWidget {
  const SuppierOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBaTitle(
            title: " Orders",
          ),
          leading: const AppBarBackButton(),
          bottom: const TabBar(indicatorColor: Colors.yellow, tabs: [
            RepeatedTab(
              label: 'Preparing',
            ),
            RepeatedTab(
              label: 'Shopping',
            ),
            RepeatedTab(
              label: 'Deliverd',
            ),
          ]),
        ),
        body: const TabBarView(children: [Preparing(), Shipping(), Delivered()]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
