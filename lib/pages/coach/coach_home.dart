import 'dart:io';

import 'package:estats/common/helper.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/basketball_home.dart';
import 'package:estats/pages/coach/football_home.dart';
import 'package:estats/pages/coach/profile/profile_page.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoachHomePage extends StatefulWidget {
  @override
  _CoachHomePageState createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {
  File currentSelectedImage;
  int currentSelectedTab = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainBGColor,
      body: ListView(
        children: <Widget>[
          Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: Container(
                      height: width * 0.085,
                      child: Image.asset(
                        'assets/main_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    actions: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProfilePage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              'assets/profile_icon_white.png',
                            ),
                            fit: BoxFit.contain,
                          )),
                          height: 38,
                          width: 38,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            currentSelectedTab = 0;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              'Football',
                                              style: TextStyle(
                                                  color: currentSelectedTab == 0
                                                      ? Colors.white
                                                      : Color(0xFF001937),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          decoration: this.currentSelectedTab ==
                                                  0
                                              ? BoxDecoration(
                                                  color: Color(0xFF001937),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)))
                                              : BoxDecoration(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            currentSelectedTab = 1;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              'Basketball',
                                              style: TextStyle(
                                                  color: currentSelectedTab == 1
                                                      ? Colors.white
                                                      : Color(0xFF001937),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          decoration: this.currentSelectedTab ==
                                                  1
                                              ? BoxDecoration(
                                                  color: Color(0xFF001937),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)))
                                              : BoxDecoration(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        currentSelectedTab == 0
                            ? FootballHome()
                            : BasketballHome()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
