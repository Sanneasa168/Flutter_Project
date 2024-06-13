import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/auth_widgets.dart';
import 'package:myapp/widgets/snackbar.dart';

class CustomerSignIn extends StatefulWidget {
  const CustomerSignIn({super.key});

  @override
  State<CustomerSignIn> createState() => _CustomerSignInState();
}

class _CustomerSignInState extends State<CustomerSignIn> {
  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;

  void navigator() {
      Navigator.pushReplacementNamed(context, '/customer_home');
    }
    
  @override
  Widget build(BuildContext context) {
   

    void logIn() async {
      setState(() {
        processing = true;
      });
      if (_formKey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          _formKey.currentState!.reset();
          navigator();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user not round') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldkey, "No user found for that email");
          } else if (e.code == 'wrong-password') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldkey, "Wrong password provided for that user ");
          }
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldkey, "Please fill all  fields");
      }
    }

    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeaderLabel(hearlabel: "Log In"),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please inter your email ";
                          } else if (value.isValidEmail() == false) {
                            return 'invalid email';
                          } else if (value.isValidEmail() == true) {
                            return null;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFormDecoration.copyWith(
                          labelText: "Email Address",
                          hintText: "Enter your Email ",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please inter your password  ";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: passwordVisible,
                        decoration: textFormDecoration.copyWith(
                          prefixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.purple,
                            ),
                          ),
                          labelText: "Password",
                          hintText: "Enter your Password",
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forget Password ?",
                          style: TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                        )),
                    HaveAccount(
                      haveAccount: "Don't have account ?",
                      actionLable: "Sign Up",
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/customer_signup');
                      },
                    ),
                    processing == true
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.purple,
                          ))
                        : AuthMainButton(
                            mainButtonLabel: "Log In",
                            onPressed: () {
                              logIn();
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
