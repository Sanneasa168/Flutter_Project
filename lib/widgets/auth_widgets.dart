import 'package:flutter/material.dart';



class AuthMainButton extends StatelessWidget {

  final String mainButtonLabel;
  final Function() onPressed;
  const AuthMainButton({
    super.key,
    required this.mainButtonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Material(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(25),
        child: MaterialButton(
          minWidth:double.infinity,
          onPressed: onPressed,
          child:  Text(
            mainButtonLabel,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),
          ),
        ),
      ),
    );
  }
}


class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLable;
  final Function() onPressed;
  const HaveAccount({
    super.key,
    required this.actionLable,
    required this.haveAccount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          haveAccount,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        TextButton(
          onPressed:onPressed, 
         child:  Text(
          actionLable
          ,style: const TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          fontSize: 20
         ),),
        ),
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String hearlabel;
  const AuthHeaderLabel({
    super.key,
    required this.hearlabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
           hearlabel,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home_work,
                size: 40,
              )),
        ],
      ),
    );
  }
}


var textFormDecoration = InputDecoration(
                      labelText: 'Full Name',
                      hintText: "Enter your full name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.purple, width: 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    );

extension   EmailValidator on String{
   bool isValidEmail (){
        return RegExp(
          // '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]'
          r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$'
        )
          .hasMatch(this);
   }
}
