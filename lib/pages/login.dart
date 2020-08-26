import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/fan/fan_home.dart';
import 'package:estats/pages/fan/fan_payment_page.dart';
import 'package:estats/pages/fan/payment_page.dart';
import 'package:estats/pages/reset_password.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void signIn(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    if (email == '' || password == '') {
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
        AuthResult user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        DocumentSnapshot snap = await Firestore.instance
            .collection('users')
            .document('${user.user.uid}')
            .get();
        bool isCoach = snap.data['isCoach'];
        setState(() {
          isLoading = false;
        });
        if (isCoach) {
          if (snap.data.containsKey('paid')) {
            if (snap.data['paid']) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CoachHomePage()));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PaymentPage()));
            }
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => PaymentPage()));
          }
        } else {
          if (snap.data.containsKey('paid')) {
            if (snap.data['paid']) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => FanHomePage()));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => FanPaymentPage()));
            }
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => FanPaymentPage()));
          }
          
        }
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
                        'Log In',
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
                        height: height * 0.014,
                      ),
                      CustomTextBox(
                        placeholderText: 'Password',
                        controller: passwordController,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      PrimaryButton(
                        onPressed: (context) {
                          signIn(context);
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              color: mainBGColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ResetPasswordPage()));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: height * 0.277,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                        onPressed: (context) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignUpPage(
                                        isCoach: true,
                                      )));
                        },
                        child: Text(
                          'Coach Sign Up',
                          style: TextStyle(
                              color: mainBGColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SecondaryButton(
                        onPressed: (context) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignUpPage(
                                        isCoach: false,
                                      )));
                        },
                        child: Text(
                          'Fan Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
