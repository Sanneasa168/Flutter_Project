import 'package:flutter/material.dart';
import 'package:myapp/auth/supplier_login.dart';
import 'package:myapp/auth/customer_login.dart';
import 'package:myapp/auth/customer_signup.dart';
import 'package:myapp/auth/supplier_sigup.dart';
import 'package:myapp/main_screen/custome_home.dart';
import 'package:myapp/main_screen/supplier_home.dart';
import 'package:myapp/main_screen/wellcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/provider/card_provider.dart';
import 'package:myapp/provider/wish_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      // home:  const WellcomeScreen(),
      initialRoute: '/wellcome_screen',
      routes: {
        '/wellcome_screen': (context) => const WellcomeScreen(),
        '/customer_home': (context) => const CustomeHome(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerSignIn(),
        '/supplier_signup': (context) => const SuppliersRegister(),
        '/supplier_login': (context) => const SuppliersLogin(),
      },
    );
  }
}
