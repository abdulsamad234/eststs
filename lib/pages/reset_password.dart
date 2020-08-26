import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/fan/fan_home.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void resetPassword(BuildContext context) async {
    String email = emailController.text;
    if (email == '') {
      showDialog(
        context: context,
        builder: (_) => PopUp(
          childWidget: Text(
            'No fields can be left empty',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        print('app name: ${FirebaseAuth.instance.app.name}');
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email);
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
         showDialog(
          context: context,
          builder: (_) => PopUp(
            childWidget: Text(
              'An email with instructions on how to reset your password has been sent to you. Please check your email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        );
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        print("The error from firebase: ${error.code}");
        print("Error: ${error.message}");
        showDialog(
          context: context,
          builder: (_) => PopUp(
            childWidget: Text(
              '${error.message}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainBGColor,
      body: Stack(
        children: <Widget>[
          ListView(
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: height * 0.213,
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  width: width,
                  child: Image.asset(
                    'assets/main_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                height: height * 0.51,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Reset Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      CustomTextBox(
                        placeholderText: 'E-mail',
                        controller: emailController,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      PrimaryButton(
                        onPressed: (context) {
                          resetPassword(context);
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                              color: mainBGColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      backgroundColor: mainBGColor,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
