import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/pages/coach/basketball/basketball_new_game/basketball_new_game.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/new_game/football_new_game.dart';
import 'package:estats/pages/fan/fan_home.dart';
import 'package:estats/pages/fan/fan_payment_page.dart';
import 'package:estats/pages/fan/payment_page.dart';
import 'package:estats/pages/login.dart';
import 'package:estats/services/dataservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        title: 'Estats',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Nunito'),
        home: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    // FirebaseAuth.instance.signOut();

    // FirebaseApp.configure(
    //     name: 'estats',
    //     options: FirebaseOptions(
    //         projectID: 'estats-7f8d6',
    //         apiKey: 'AIzaSyAVlrJCX1rG4MPKC1SDrIusJrplJMBCIfw',
    //         googleAppID: '1:835107260534:ios:52434475342c922365b757'));
    // FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // User currentUser = await Helper

    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 5,
          navigateAfterSeconds: new AfterSplash(),
          // title: new Text('Welcome In SplashScreen',
          // style: new TextStyle(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 20.0
          // ),),
          loaderColor: Colors.transparent,
          backgroundColor: Colors.white,

          // styleTextUnderTheLoader: new TextStyle(),
          // loaderColor: Colors.red
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/main_logo.png'),
                    fit: BoxFit.fitWidth)),
          ),
        )
      ],
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return TaglinePage();

    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> currentUser) {
        if (currentUser.hasData) {
          print('current user: ${currentUser.data.uid}');
          return FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance
                .collection('users')
                .document(currentUser.data.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> currentUserData) {
              if (currentUserData.data.data['isCoach']) {
                return FutureBuilder<bool>(
                    future: DataService().isGameGoingOn(currentUser.data.uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> isGameGoingOn) {
                      if (isGameGoingOn.data) {
                        print('Game going on: ${isGameGoingOn.data}');
                        return FootballNewGame();
                      }
                      return FutureBuilder<bool>(
                          future: DataService()
                              .isBasketballGameGoingOn(currentUser.data.uid),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> isGameGoingOn) {
                            if (isGameGoingOn.data) {
                              print('Game going on: ${isGameGoingOn.data}');
                              return BasketballNewGame();
                            }
                            if (currentUserData.data.data.containsKey('paid')) {
                              if (currentUserData.data.data['paid']) {
                                return CoachHomePage();
                              } else {
                                return PaymentPage();
                                // return CoachHomePage();
                              }
                            } else {
                              return PaymentPage();
                              // return CoachHomePage();
                            }

                          });
                    });
              } else {
                if (currentUserData.data.data.containsKey('paid')) {
                  if (currentUserData.data.data['paid']) {
                    print('Going to fan home');
                    return FanHomePage();
                  } else {
                    print('Going to fan payment page');
                    return FanPaymentPage();
                    // return FanHomePage();
                  }
                } else {
                  print('Going to fan payment page');
                  return FanPaymentPage();
                  // return FanHomePage();
                }
              }
            },
          );
        } else {
          return LoginPage();
        }
      },
    );
  }
}
