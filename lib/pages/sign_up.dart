import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/common/helper.dart';
import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/fan/fan_home.dart';
import 'package:estats/pages/fan/fan_payment_page.dart';
import 'package:estats/pages/fan/payment_page.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:us_states/us_states.dart';

class SignUpPage extends StatefulWidget {
  final bool isCoach;
  SignUpPage({this.isCoach});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  File currentSelectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController schoolnNameController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  List<DropdownMenuItem<dynamic>> items = List<DropdownMenuItem<dynamic>>();
  List<DropdownMenuItem<dynamic>> schoolItems =
      List<DropdownMenuItem<dynamic>>();
  bool isLoading = false;
  String currentSelectedState = '';
  String currentSelectedSchool = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStates();
  }

  initStates() async {
    List<String> nameList = USStates.getAllNames();
    List<String> abbvList = USStates.getAllAbbreviations();
    List<String> schoolNames = await DataService().getSchools();
    for (int j = 0; j < schoolNames.length; j++) {
      schoolItems.add(DropdownMenuItem(
        child: Text('${schoolNames[j]}'),
        value: schoolNames[j],
      ));
    }
    for (int i = 0; i < nameList.length; i++) {
      setState(() {
        items.add(DropdownMenuItem(
          child: Text('${nameList[i]} - ${abbvList[i]}'),
          value: abbvList[i],
        ));
      });
    }
  }

  Future<String> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  void signUp(BuildContext context) async {
    String name = nameController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String schoolName = '';
    if (widget.isCoach) {
      schoolName = schoolnNameController.text;
    } else {
      schoolName = currentSelectedSchool;
    }
    print('School name: $schoolName');
    print('name: $name');
    print('User name: $username');
    print('email: $email');
    print('School name: $schoolName');
    String state = currentSelectedState;
    String teamName = teamNameController.text;
    if (name == '' ||
        username == '' ||
        email == '' ||
        password == '' ||
        schoolName == '' ||
        state == '' ||
        (widget.isCoach && currentSelectedImage == null) ||
        (widget.isCoach && teamName == '')) {
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
      print('Got here though');
      setState(() {
        isLoading = true;
      });
      try {
        String currentDate = DateTime.now().toString();
        String url = '';
        if (widget.isCoach) {
          QuerySnapshot snapHere = await Firestore.instance
              .collection('users')
              .where('schoolName', isEqualTo: schoolName)
              .getDocuments();
          if (snapHere.documents.length > 0) {
            setState(() {
              isLoading = false;
            });
            showDialog(
              context: context,
              builder: (_) => PopUp(
                childWidget: Text(
                  'School name already chosen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            );
            return;
          }
          url = await _uploadFile(currentSelectedImage, '${currentDate}');
        }
        AuthResult user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = name;
        user.user.updateProfile(userUpdateInfo).then((onValue) async {
          Map<String, dynamic> userValues = Map<String, dynamic>();

          if (widget.isCoach) {
            userValues = {
              'email': email,
              'fullName': name,
              'isCoach': widget.isCoach,
              'username': username,
              'schoolName': schoolName,
              'state': state,
              'badgeUrl': url,
              'teamName': teamName
            };
          } else {
            userValues = {
              'email': email,
              'fullName': name,
              'isCoach': widget.isCoach,
              'username': username,
              'schoolName': schoolName,
              'state': state
            };
          }
          Firestore.instance
              .collection('users')
              .document('${user.user.uid}')
              .setData(userValues)
              .then((returned) {
            setState(() {
              isLoading = false;
            });
            
            widget.isCoach
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PaymentPage()))
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => FanPaymentPage()));
          });
        });

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) =>
        //             DashboardPage()));
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        // print("The error from firebase: ${error.code}");
        print("Error: ${error.toString()}");
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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    // Container(
                    // height: height * 0.81,
                    // child:
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AppBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            centerTitle: true,
                            title: widget.isCoach
                                ? Text(
                                    'Coach Sign Up',
                                    style: TextStyle(color: Color(0xFF001937)),
                                  )
                                : Text('Fan Sign Up',
                                    style: TextStyle(color: Color(0xFF001937))),
                            leading: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Color(0xFF001937),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                widget.isCoach
                                    ? Column(
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
                                                              source:
                                                                  ImageSource
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
                                                              source:
                                                                  ImageSource
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
                                              child: Center(
                                                child: SizedBox(
                                                  height: width * 0.08,
                                                  child: currentSelectedImage ==
                                                          null
                                                      ? Image.asset(
                                                          'assets/camera_icon.png',
                                                          fit: BoxFit.fitHeight,
                                                        )
                                                      : Container(),
                                                ),
                                              ),
                                              decoration: currentSelectedImage ==
                                                      null
                                                  ? BoxDecoration(
                                                      color: Color(0xFFDDE4EB),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(
                                                              width * 0.06)))
                                                  : BoxDecoration(
                                                      color: Color(0xFFDDE4EB),
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              width * 0.06)),
                                                      image: DecorationImage(
                                                          image: MemoryImage(
                                                              currentSelectedImage
                                                                  .readAsBytesSync()),
                                                          fit: BoxFit.contain)),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Text('Upload School Badge',
                                              style: TextStyle(
                                                  color: Color(0xFF001937),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400)),
                                          SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                CustomTextBox(
                                  placeholderText: 'Name',
                                  textboxBackgroundColor: Color(0xFFDDE4EB),
                                  borderColor: Color(0xFFDDE4EB),
                                  textColor: Color(0xFF000000),
                                  placeholderColor: Color(0x33000000),
                                  controller: nameController,
                                ),
                                SizedBox(
                                  height: height * 0.014,
                                ),
                                CustomTextBox(
                                  placeholderText: 'Username',
                                  textboxBackgroundColor: Color(0xFFDDE4EB),
                                  borderColor: Color(0xFFDDE4EB),
                                  textColor: Color(0xFF000000),
                                  placeholderColor: Color(0x33000000),
                                  controller: usernameController,
                                ),
                                SizedBox(
                                  height: height * 0.014,
                                ),
                                CustomTextBox(
                                  placeholderText: 'E-mail',
                                  controller: emailController,
                                  textboxBackgroundColor: Color(0xFFDDE4EB),
                                  borderColor: Color(0xFFDDE4EB),
                                  textColor: Color(0xFF000000),
                                  placeholderColor: Color(0x33000000),
                                ),
                                SizedBox(
                                  height: height * 0.014,
                                ),
                                CustomTextBox(
                                  placeholderText: 'Password',
                                  obscureText: true,
                                  textboxBackgroundColor: Color(0xFFDDE4EB),
                                  borderColor: Color(0xFFDDE4EB),
                                  textColor: Color(0xFF000000),
                                  placeholderColor: Color(0x33000000),
                                  controller: passwordController,
                                ),
                                SizedBox(
                                  height: height * 0.014,
                                ),
                                widget.isCoach
                                    ? CustomTextBox(
                                        placeholderText: 'School Name',
                                        textboxBackgroundColor:
                                            Color(0xFFDDE4EB),
                                        borderColor: Color(0xFFDDE4EB),
                                        textColor: Color(0xFF000000),
                                        placeholderColor: Color(0x33000000),
                                        controller: schoolnNameController,
                                      )
                                    : CustomTextBox(
                                        // placeholderText: 'State',
                                        textboxBackgroundColor:
                                            Color(0xFFDDE4EB),
                                        borderColor: Color(0xFFDDE4EB),
                                        textColor: Color(0xFF000000),
                                        placeholderColor: Color(0x33000000),
                                        controller: schoolnNameController,
                                        enabled: false,
                                        child: SearchableDropdown.single(
                                          items: schoolItems,
                                          value: currentSelectedSchool,
                                          hint: "Select School",
                                          searchHint: "Select School",
                                          onChanged: (value) {
                                            setState(() {
                                              currentSelectedSchool = value;
                                            });
                                          },
                                          isExpanded: true,
                                        ),
                                      ),
                                widget.isCoach
                                    ? Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: height * 0.014,
                                          ),
                                          CustomTextBox(
                                            placeholderText: 'Team Name',
                                            textboxBackgroundColor:
                                                Color(0xFFDDE4EB),
                                            borderColor: Color(0xFFDDE4EB),
                                            textColor: Color(0xFF000000),
                                            placeholderColor: Color(0x33000000),
                                            controller: teamNameController,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: height * 0.014,
                                ),
                                CustomTextBox(
                                  // placeholderText: 'State',
                                  textboxBackgroundColor: Color(0xFFDDE4EB),
                                  borderColor: Color(0xFFDDE4EB),
                                  textColor: Color(0xFF000000),
                                  placeholderColor: Color(0x33000000),
                                  controller: stateController,
                                  enabled: false,
                                  child: SearchableDropdown.single(
                                    items: items,
                                    value: currentSelectedState,
                                    hint: "Select state",
                                    searchHint: "Select state",
                                    onChanged: (value) {
                                      setState(() {
                                        currentSelectedState = value;
                                      });
                                    },
                                    isExpanded: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    PrimaryButton(
                      onPressed: (context) {
                        signUp(context);
                      },
                      bgColor: Color(0xFF004381),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
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
