import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/dashoad_component/edit_bussiness.dart';
import 'package:myapp/dashoad_component/manae_product.dart';
// import 'package:myapp/dashoad_component/my_store.dart';
import 'package:myapp/dashoad_component/supp_balance.dart';
import 'package:myapp/dashoad_component/supp_orders.dart';
import 'package:myapp/dashoad_component/supp_statics.dart';
import 'package:myapp/minor_screen/visit_stores.dart';
import 'package:myapp/widgets/alert_dialog.dart';
import 'package:myapp/widgets/appbar_widgets.dart';

List<String> label = [
  'my store',
  'orders',
  'edit profilt',
  'menage product',
  'balance',
  'statics',
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

List<Widget> pages = [
  VisitStores(suppID: FirebaseAuth.instance.currentUser!.uid),
  const SuppierOrder(),
  const Editbusiness(),
  const MangeProduct(),
  const BalanceScreen(),
  const StaticsScreen()
];

class DashboadScreen extends StatefulWidget {
  const DashboadScreen({super.key});

  @override
  State<DashboadScreen> createState() => _DashboadScreenState();
}

class _DashboadScreenState extends State<DashboadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const AppBaTitle(
          title: 'Dashboad',
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/wellcome_screen');
              MyAlertDailaog.showDailaog(
                context: context,
                title: "Log Out",
                content: "Are you  sure for log out ?",
                tapNo: () {
                  Navigator.pop(context);
                },
                tapYes: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/wellcome_screen');
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 50,
            crossAxisSpacing: 50,
            children: List.generate(6, (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => pages[index]));
                },
                child: Card(
                  elevation: 20,
                  shadowColor: Colors.purpleAccent.shade200,
                  color: Colors.blueGrey.withOpacity(0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        icons[index],
                        color: Colors.yellow,
                        size: 50,
                      ),
                      Text(
                        label[index].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 24,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              );
            })),
      ),
    );
  }
}
