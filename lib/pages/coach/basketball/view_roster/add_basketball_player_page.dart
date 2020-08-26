import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/common/helper.dart';
import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:us_states/us_states.dart';

class AddBasketballPlayerPage extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic> playerData;
  AddBasketballPlayerPage({this.isEditing = false, this.playerData});
  @override
  _AddBasketballPlayerPageState createState() =>
      _AddBasketballPlayerPageState();
}

class _AddBasketballPlayerPageState extends State<AddBasketballPlayerPage> {
  File currentSelectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  List<DropdownMenuItem<dynamic>> items = List<DropdownMenuItem<dynamic>>();
  bool isLoading = false;
  String currentSelectedPosition = '';
  int currentSelected = -1;
  List<String> leftArr = ['Assist', 'Steal', 'Foul'];
  List<String> rightArr = ['Rebound', 'Block', 'Turnover'];
  List<int> leftActiveArr = [0, 0, 0];
  List<int> rightActiveArr = [0, 0, 0];
  List<String> prepopulateArray = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPositions();
    initCurrentPlayer();
    print('Widget current player: ${widget.playerData}');
  }

  initCurrentPlayer() {
    setState(() {
      if (widget.isEditing) {
        numberController.text = '${widget.playerData['number']}';
        nameController.text = '${widget.playerData['fullName']}';
        ageController.text = '${widget.playerData['age']}';
        currentSelectedPosition = '${widget.playerData['position']}';
        heightController.text = '${widget.playerData['height']}';
        weightController.text = '${widget.playerData['weight']}';
        List prepopulate = widget.playerData['prepopulate'];
        prepopulate.forEach((current) {
          prepopulateArray.add(current);
          if (leftArr.contains(current)) {
            leftActiveArr[leftArr.indexOf(current)] = 1;
          }
          if (rightArr.contains(current)) {
            rightActiveArr[rightArr.indexOf(current)] = 1;
          }
        });
      }
    });

    // .text = '${widget.playerData['fullName']}';
    // nameController.text = '${widget.playerData['fullName']}';
    // nameController.text = '${widget.playerData['fullName']}';
  }

  initPositions() {
    List<String> positionsList = [
      'PG - Point Guard',
      'SG - Shooting Guard',
      'SF - Small Forward',
      'PF - Power Forward',
      'C - Center',
    ];

    for (int i = 0; i < positionsList.length; i++) {
      setState(() {
        items.add(DropdownMenuItem(
          child: Text('${positionsList[i]}'),
          value: positionsList[i],
        ));
      });
    }
  }

  Future<void> addPlayer() async {
    String name = nameController.text;

    String position = currentSelectedPosition;
    if (name == '' ||
        numberController.text == '' ||
        ageController.text == '' ||
        heightController.text == '' ||
        weightController.text == '' ||
        currentSelectedPosition == '' ||
        currentSelectedImage == null) {
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
      int number = int.parse('${numberController.text}');
      int age = int.parse('${ageController.text}');
      double height = double.parse('${heightController.text}');
      double weight = double.parse('${weightController.text}');
      String nowDate = DateTime.now().toString();
      String url = await _uploadFile(currentSelectedImage, nowDate);
      Map<String, dynamic> playerData = {
        'fullName': name,
        'number': number,
        'age': age,
        'height': height,
        'imageUrl': url,
        'weight': weight,
        'position': position,
        'prepopulate': prepopulateArray
      };
      DataService().addBasketballPlayer(playerData).then((nothing) {
        setState(() {
          isLoading = false;
        });
        if (nothing) {
          Navigator.pop(context, true);
        } else {
          showDialog(
            context: context,
            builder: (_) => PopUp(
              childWidget: Text(
                'The player with that number already exists',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          );
        }
      });
    }
  }

  Future<void> savePlayer() async {
    String name = nameController.text;

    String position = currentSelectedPosition;
    if (name == '' ||
        numberController.text == '' ||
        ageController.text == '' ||
        heightController.text == '' ||
        weightController.text == '' ||
        currentSelectedPosition == '') {
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
      int number = int.parse('${numberController.text}');
      int age = int.parse('${ageController.text}');
      double height = double.parse('${heightController.text}');
      double weight = double.parse('${weightController.text}');
      String nowDate = DateTime.now().toString();
      Map<String, dynamic> playerData;
      if (currentSelectedImage == null) {
        playerData = {
          'fullName': name,
          'number': number,
          'age': age,
          'height': height,
          'imageUrl': widget.playerData['imageUrl'],
          'weight': weight,
          'position': position,
          'prepopulate': prepopulateArray
        };
      } else {
        String url = await _uploadFile(currentSelectedImage, nowDate);
        playerData = {
          'fullName': name,
          'number': number,
          'age': age,
          'height': height,
          'imageUrl': url,
          'weight': weight,
          'position': position,
          'prepopulate': prepopulateArray
        };
      }

      DataService()
          .saveBasketballPlayer(playerData, widget.playerData['documentId'])
          .then((nothing) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context, true);
      });
    }
  }

  Future<void> deletePlayer() async {
    showDialog(
      context: context,
      builder: (_) => PopUp(
        childWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Are you sure you want to delete?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('YES'),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    DataService()
                        .deletePlayer(widget.playerData['documentId'])
                        .then((nothing) {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: !isLoading
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        // Container(
                        // height: height * 0.81,
                        // child:
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              AppBar(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                centerTitle: true,
                                title: Text(
                                    widget.isEditing
                                        ? 'Edit Player'
                                        : 'New Player',
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
                                    Column(
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
                                            child: Center(
                                              child: SizedBox(
                                                height: width * 0.08,
                                                child: widget.isEditing
                                                    ? (widget.playerData[
                                                                'imageUrl'] ==
                                                            ''
                                                        ? Image.asset(
                                                            'assets/camera_icon.png',
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          )
                                                        : Container())
                                                    : currentSelectedImage ==
                                                            null
                                                        ? Image.asset(
                                                            'assets/camera_icon.png',
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          )
                                                        : Container(),
                                              ),
                                            ),
                                            decoration: widget.isEditing
                                                ? BoxDecoration(
                                                    color: Color(0xFFDDE4EB),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            width * 0.06)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            '${widget.playerData['imageUrl']}'),
                                                        fit: BoxFit.cover))
                                                : (currentSelectedImage == null
                                                    ? BoxDecoration(
                                                        color:
                                                            Color(0xFFDDE4EB),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                width * 0.06)))
                                                    : BoxDecoration(
                                                        color:
                                                            Color(0xFFDDE4EB),
                                                        borderRadius: BorderRadius.all(Radius.circular(width * 0.06)),
                                                        image: DecorationImage(image: MemoryImage(currentSelectedImage.readAsBytesSync()), fit: BoxFit.cover))),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text('Upload Player\'s Picture',
                                            style: TextStyle(
                                                color: Color(0xFF001937),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400)),
                                        SizedBox(
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                    CustomTextBox(
                                      placeholderText: 'Number',
                                      textboxBackgroundColor: Color(0xFFDDE4EB),
                                      borderColor: Color(0xFFDDE4EB),
                                      textColor: Color(0xFF000000),
                                      placeholderColor: Color(0x33000000),
                                      controller: numberController,
                                    ),
                                    SizedBox(
                                      height: height * 0.014,
                                    ),
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
                                      placeholderText: 'Age',
                                      controller: ageController,
                                      textboxBackgroundColor: Color(0xFFDDE4EB),
                                      borderColor: Color(0xFFDDE4EB),
                                      textColor: Color(0xFF000000),
                                      placeholderColor: Color(0x33000000),
                                      keyboardType: TextInputType.number,
                                    ),
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
                                        value: currentSelectedPosition,
                                        hint: "Position",
                                        underline: Container(),
                                        searchHint: "Search position",
                                        onChanged: (value) {
                                          print('Value: $value');
                                          setState(() {
                                            currentSelectedPosition = value;
                                            print(
                                                'current position now: $currentSelectedPosition');
                                          });
                                        },
                                        isExpanded: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.014,
                                    ),
                                    CustomTextBox(
                                      placeholderText: 'HT (in ft)',
                                      // obscureText: true,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      textboxBackgroundColor: Color(0xFFDDE4EB),
                                      borderColor: Color(0xFFDDE4EB),
                                      textColor: Color(0xFF000000),
                                      placeholderColor: Color(0x33000000),
                                      controller: heightController,
                                    ),
                                    SizedBox(
                                      height: height * 0.014,
                                    ),
                                    CustomTextBox(
                                      placeholderText: 'Weight (in lb)',
                                      textboxBackgroundColor: Color(0xFFDDE4EB),
                                      borderColor: Color(0xFFDDE4EB),
                                      textColor: Color(0xFF000000),
                                      placeholderColor: Color(0x33000000),
                                      controller: weightController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                    ),
                                    SizedBox(
                                      height: height * 0.016,
                                    ),
                                    // Text('Stats Prepopulate',
                                    //     style: TextStyle(
                                    //         color: mainBGColor,
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.w600)),
                                    // SizedBox(
                                    //   height: height * 0.016,
                                    // ),
                                    // Column(
                                    //   children: List.generate(leftArr.length,
                                    //       (index) {
                                    //     return Column(
                                    //       children: <Widget>[
                                    //         Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment
                                    //                   .spaceBetween,
                                    //           children: <Widget>[
                                    //             Expanded(
                                    //               child: SecondaryButton(
                                    //                 borderColor: mainBGColor,
                                    //                 isSelected:
                                    //                     leftActiveArr[index] ==
                                    //                         1,
                                    //                 onPressed: (context) {
                                    //                   setState(() {
                                    //                     if (leftActiveArr[
                                    //                             index] ==
                                    //                         1) {
                                    //                       leftActiveArr[index] =
                                    //                           0;
                                    //                       prepopulateArray
                                    //                           .remove(leftArr[
                                    //                               index]);
                                    //                     } else {
                                    //                       leftActiveArr[index] =
                                    //                           1;
                                    //                       prepopulateArray.add(
                                    //                           leftArr[index]);
                                    //                     }
                                    //                     print(
                                    //                         'current arr now: $prepopulateArray');
                                    //                   });
                                    //                 },
                                    //                 child: Text(
                                    //                   '${leftArr[index]}',
                                    //                   style: TextStyle(
                                    //                       color: leftActiveArr[
                                    //                                   index] ==
                                    //                               1
                                    //                           ? whiteColor
                                    //                           : mainBGColor,
                                    //                       fontWeight:
                                    //                           FontWeight.w600,
                                    //                       fontSize: 17),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             SizedBox(
                                    //               width: 20,
                                    //             ),
                                    //             Expanded(
                                    //               child: SecondaryButton(
                                    //                 isSelected:
                                    //                     rightActiveArr[index] ==
                                    //                         1,
                                    //                 onPressed: (context) {
                                    //                   setState(() {
                                    //                     if (rightActiveArr[
                                    //                             index] ==
                                    //                         1) {
                                    //                       rightActiveArr[
                                    //                           index] = 0;
                                    //                       prepopulateArray
                                    //                           .remove(rightArr[
                                    //                               index]);
                                    //                     } else {
                                    //                       rightActiveArr[
                                    //                           index] = 1;
                                    //                       prepopulateArray.add(
                                    //                           rightArr[index]);
                                    //                     }
                                    //                     print(
                                    //                         'current arr now: $prepopulateArray');
                                    //                   });
                                    //                 },
                                    //                 borderColor: mainBGColor,
                                    //                 child: Text(
                                    //                   '${rightArr[index]}',
                                    //                   style: TextStyle(
                                    //                       color: rightActiveArr[
                                    //                                   index] ==
                                    //                               1
                                    //                           ? whiteColor
                                    //                           : mainBGColor,
                                    //                       fontWeight:
                                    //                           FontWeight.w600,
                                    //                       fontSize: 17),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         SizedBox(
                                    //           height: 10,
                                    //         )
                                    //       ],
                                    //     );
                                    //   }),
                                    // )
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
                            widget.isEditing ? savePlayer() : addPlayer();
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
                        widget.isEditing
                            ? SizedBox(
                                height: 10,
                              )
                            : Container(),
                        widget.isEditing
                            ? PrimaryButton(
                                onPressed: (context) {
                                  deletePlayer();
                                },
                                bgColor: Color(0xFFF4072D),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            : Align(
                alignment: Alignment.center,
                child: Container(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    backgroundColor: mainBGColor,
                  ),
                ),
              ));
  }
}
