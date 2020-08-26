import 'dart:io';

import 'package:estats/common/helper.dart';
import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/components/number_card.dart';
import 'package:estats/pages/coach/new_game/components/player_action_bottom.dart';
import 'package:estats/pages/coach/new_game/components/player_action_card.dart';
import 'package:estats/pages/coach/profile/components/ordinary_button.dart';
import 'package:estats/pages/login.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  // String currentNumber = '';
  bool isLoading = false;
  bool isDeleteEnabled = false;
  File currentSelectedImage;
  String currImageUrl = '';
  Map<String, dynamic> userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() {
    setState(() {
      isLoading = true;
    });
    DataService().getCurrentUserData().then((newUserData) {
      setState(() {
        userData = newUserData;
        isLoading = false;
        nameController.text =
            userData.containsKey('fullName') ? userData['fullName'] : '';
        schoolNameController.text =
            userData.containsKey('schoolName') ? userData['schoolName'] : '';
        teamNameController.text =
            userData.containsKey('teamName') ? userData['teamName'] : '';
        emailController.text =
            userData.containsKey('email') ? userData['email'] : '';
        currImageUrl =
            userData.containsKey('badgeUrl') ? userData['badgeUrl'] : '';
      });
    });
  }

  logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  update() async {
    setState(() {
      isLoading = true;
    });
    String currentDate = DateTime.now().toString();
    if (currentSelectedImage != null) {
      String url =
          await DataService().uploadFile(currentSelectedImage, currentDate);
      setState(() {
        userData['badgeUrl'] = url;
      });
    }
    setState(() {
      userData['fullName'] = nameController.text;
      userData['schoolName'] = schoolNameController.text;
      userData['teamName'] = teamNameController.text;
      userData['email'] = emailController.text;
    });
    DataService().updateCurrentUserData(userData).then((t) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: <Widget>[
          !isLoading ? Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          leading: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: darkBGColor,
                            ),
                          ),
                          title: Text(
                            'Profile Settings',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: darkBGColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              userData['isCoach']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Helper().showBottomSheet(
                                                context,
                                                'Choose',
                                                'Choose image from library or take a new photo',
                                                [
                                                  'Take new photo',
                                                  'Choose from library'
                                                ],
                                                [
                                                  () async {
                                                    var image = await ImagePicker
                                                        .pickImage(
                                                            source: ImageSource
                                                                .camera);
                                                    setState(() {
                                                      currentSelectedImage =
                                                          image;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  () async {
                                                    var image = await ImagePicker
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery);
                                                    setState(() {
                                                      currentSelectedImage =
                                                          image;
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                ]);
                                          },
                                          child: Container(
                                            width: width * 0.22,
                                            height: width * 0.22,
                                            // child: Center(
                                            //   child: SizedBox(
                                            //     height: width * 0.08,
                                            //     child: currentSelectedImage == null
                                            //         ? Image.asset(
                                            //             'assets/camera_icon.png',
                                            //             fit: BoxFit.fitHeight,
                                            //           )
                                            //         : Container(),
                                            //   ),
                                            // ),
                                            decoration: currentSelectedImage ==
                                                    null
                                                ? BoxDecoration(
                                                    color: Color(0xFFDDE4EB),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                          width * 0.06),
                                                    ),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            currImageUrl),
                                                        fit: BoxFit.contain))
                                                : BoxDecoration(
                                                    color: Color(0xFFDDE4EB),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                width * 0.06)),
                                                    image: DecorationImage(
                                                        image: MemoryImage(
                                                            currentSelectedImage
                                                                .readAsBytesSync()),
                                                        fit: BoxFit.contain)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'School Badge',
                                              style: TextStyle(
                                                  color: mainBGColor,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Helper().showBottomSheet(
                                                      context,
                                                      'Choose',
                                                      'Choose image from library or take a new photo',
                                                      [
                                                        'Take new photo',
                                                        'Choose from library'
                                                      ],
                                                      [
                                                        () async {
                                                          var image = await ImagePicker
                                                              .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .camera);
                                                          setState(() {
                                                            currentSelectedImage =
                                                                image;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        () async {
                                                          var image = await ImagePicker
                                                              .pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                          setState(() {
                                                            currentSelectedImage =
                                                                image;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      ]);
                                                },
                                                child: Text(
                                                  'Edit',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ))
                                          ],
                                        )
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: 20,
                              ),
                              OrdinaryButton(
                                bgColor: whiteColor,
                                title: 'Name',
                                controller: nameController,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              OrdinaryButton(
                                bgColor: whiteColor,
                                title: 'School Name',
                                controller: schoolNameController,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              userData['isCoach']
                                  ? OrdinaryButton(
                                      bgColor: whiteColor,
                                      title: 'Team Name',
                                      controller: teamNameController,
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10,
                              ),
                              OrdinaryButton(
                                bgColor: whiteColor,
                                title: 'E-mail',
                                controller: emailController,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: PrimaryButton(
                    onPressed: (context) {
                      update();
                    },
                    bgColor: Color(0xFF004381),
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: PrimaryButton(
                    onPressed: (context) {
                      logout();
                    },
                    bgColor: Color(0xFFF4072D),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ): Container(),
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
