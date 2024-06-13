import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/custome_screen/add_address.dart';
import 'package:myapp/custome_screen/customer_order.dart';
import 'package:myapp/custome_screen/whishlist.dart';
import 'package:myapp/main_screen/cart.dart';
import 'package:myapp/widgets/alert_dialog.dart';
import 'package:myapp/widgets/appbar_widgets.dart';

class ProfitsScreen extends StatefulWidget {
  final String documentId;
  const ProfitsScreen({
    super.key,
    required this.documentId,
  });

  @override
  State<ProfitsScreen> createState() => _ProfitsScreenState();
}

class _ProfitsScreenState extends State<ProfitsScreen> {
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  CollectionReference customer =
      FirebaseFirestore.instance.collection('customer');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? anonymous.doc(widget.documentId).get()
          : customer.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 230,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.yellow,
                      Colors.brown,
                    ]),
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      elevation: 0,
                      centerTitle: true,
                      expandedHeight: 140,
                      backgroundColor: Colors.white,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          return FlexibleSpaceBar(
                            title: AnimatedOpacity(
                              opacity:
                                  constraints.biggest.height <= 120 ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Text(
                                "Account",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.yellow,
                                  Colors.brown,
                                ]),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25, left: 30),
                                    child: data['profileImage'] == ''
                                        ? const CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                                'assets/images/inapp/guest.jpg'),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                data['profileImage']),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Text(
                                        data['name'] == ''
                                            ? 'quest'.toUpperCase()
                                            : data['name'].toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                      ),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CardScreen(
                                                        back:
                                                            AppBarBackButton(),
                                                      )));
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: const Center(
                                            child: Text(
                                              'Cart',
                                              style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Container(
                                    color: Colors.yellow,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CustomerOrders()));
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: const Center(
                                            child: Text(
                                              'Orders',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WishlistScreen()));
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: const Center(
                                            child: Text(
                                              'Wishlish',
                                              style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                          Container(
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 150,
                                  child: Image.asset(
                                      'assets/images/inapp/logo.jpg'),
                                ),
                                const ProfitHeaderLabel(
                                  headerLabel: 'Account Info',
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Column(
                                      children: [
                                        ReapeatedTitle(
                                            title: 'Email Address ',
                                            subTitle: data['email'] == ''
                                                ? 'example@mail.com'
                                                : data['email'],
                                            icon: Icons.email),
                                        const YellowDivider(),
                                        ReapeatedTitle(
                                            title: 'Phone No. ',
                                            subTitle: data['phone'] == ''
                                                ? 'example + 99999'
                                                : data['phone'],
                                            icon: Icons.call),
                                        const YellowDivider(),
                                        ReapeatedTitle(
                                           onpressed: FirebaseAuth.instance.currentUser!.isAnonymous?null: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const  Address()));
                                           },
                                            title: 'Address',
                                            subTitle: data['address'] == ''
                                                ? ' example :new york city - usa'
                                                : data['address'],
                                            icon: Icons.location_on_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                                const ProfitHeaderLabel(
                                    headerLabel: "Account Setting"),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Column(children: [
                                      ReapeatedTitle(
                                          title: 'Edit Profile',
                                          subTitle: '',
                                          icon: Icons.edit,
                                          onpressed: () {}),
                                      const YellowDivider(),
                                      const ReapeatedTitle(
                                        title: 'Changed Password',
                                        icon: Icons.lock,
                                      ),
                                      const YellowDivider(),
                                      ReapeatedTitle(
                                        onpressed: () async {
                                          MyAlertDailaog.showDailaog(
                                            context: context,
                                            title: "Log Out",
                                            content:
                                                "Are you  sure for log out ?",
                                            tapNo: () {
                                              Navigator.pop(context);
                                            },
                                            tapYes: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              await Future.delayed(
                                                      const Duration(
                                                          microseconds: 100))
                                                  .whenComplete(() {
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                    context,
                                                    '/wellcome_screen');
                                              });
                                            },
                                          );
                                        },
                                        title: 'LogOut',
                                        icon: Icons.logout,
                                      ),
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
          // Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        );
      },
    );
  }
  String userAddress(){
    return "example:New Jersey-USA";
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class ReapeatedTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onpressed;
  const ReapeatedTitle({
    super.key,
    required this.title,
    this.subTitle = '',
    required this.icon,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfitHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfitHeaderLabel({
    super.key,
    required this.headerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: const TextStyle(
                color: Colors.grey, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
