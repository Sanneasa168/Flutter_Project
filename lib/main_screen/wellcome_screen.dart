import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/yellow_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const textColors = [
  Colors.yellowAccent,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.teal,
];
const textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
);

class WellcomeScreen extends StatefulWidget {
  const WellcomeScreen({super.key});

  @override
  State<WellcomeScreen> createState() => _WellcomeScreenState();
}

class _WellcomeScreenState extends State<WellcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool processing = false;

  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  late String _uid;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/inapp/bgimage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText("WELCOME",
                      textStyle: textStyle, colors: textColors),
                  ColorizeAnimatedText("Duck Store",
                      textStyle: textStyle, colors: textColors),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              const SizedBox(
                height: 120,
                width: 200,
                child: Image(image: AssetImage('assets/images/inapp/logo.jpg')),
              ),
              SizedBox(
                height: 80,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('AWESOME'),
                      RotateAnimatedText('OPTIMISTIC'),
                      RotateAnimatedText('DIFFERENT'),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Subliers only",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white30.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AnimationLogo(controller: _controller),
                              YellowButton(
                                label: 'Log In',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/supplier_login');
                                },
                                width: 0.25,
                              ),
                              YellowButton(
                                label: ' Sign Up',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/supplier_signup');
                                },
                                width: 0.25,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: const BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          YellowButton(
                            label: 'Log In',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/customer_login');
                            },
                            width: 0.25,
                          ),
                          YellowButton(
                            label: 'Sign Up',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/customer_signup');
                            },
                            width: 0.25,
                          ),
                          AnimationLogo(controller: _controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Container(
                    decoration: const BoxDecoration(color: Colors.white38),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GoogleFacebookLogin(
                          label: 'Google',
                          onPressed: () {},
                          child: const Image(
                              image:
                                  AssetImage('assets/images/inapp/google.jpg')),
                        ),
                        GoogleFacebookLogin(
                          label: 'Facebook',
                          onPressed: () {},
                          child: const Image(
                              image: AssetImage(
                                  'assets/images/inapp/facebook.jpg')),
                        ),
                        processing == true
                            ? const CircularProgressIndicator()
                            : GoogleFacebookLogin(
                                label: 'Guest',
                                onPressed: () async {
                                  setState(() {
                                    processing = true;
                                  });
                                  await FirebaseAuth.instance
                                      .signInAnonymously()
                                      .whenComplete(() async {
                                    _uid =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    await anonymous.doc(_uid).set({
                                      'name': '',
                                      'email': '',
                                      'profileImage': '',
                                      'phone': '',
                                      'address': '',
                                      'cid': _uid,
                                    });
                                  });

                                  Navigator.pushReplacementNamed(
                                      context, '/customer_home');
                                },
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimationLogo extends StatelessWidget {
  const AnimationLogo({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Image(
        image: AssetImage('assets/images/inapp/logo.jpg'),
      ),
    );
  }
}

class GoogleFacebookLogin extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget child;
  const GoogleFacebookLogin({
    super.key,
    required this.label,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(children: [
          SizedBox(
            height: 50,
            width: 50,
            child: child,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ]),
      ),
    );
  }
}
