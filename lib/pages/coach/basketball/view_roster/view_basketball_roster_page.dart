import 'dart:io';

import 'package:estats/common/helper.dart';
import 'package:estats/pages/coach/basketball/view_roster/add_basketball_player_page.dart';
import 'package:estats/pages/coach/stats/components/stats_history_cell.dart';
import 'package:estats/pages/coach/stats/stats_page.dart';
// import 'package:estats/pages/coach/view_roster/add_player_page.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:image_picker/image_picker.dart';

class ViewBasketballRosterPage extends StatefulWidget {
  @override
  _ViewBasketballRosterPageState createState() =>
      _ViewBasketballRosterPageState();
}

class _ViewBasketballRosterPageState extends State<ViewBasketballRosterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  List<Map<String, dynamic>> players = List<Map<String, dynamic>>();

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('NAME', 200),
      _getTitleItemWidget('No.', 40),
      _getTitleItemWidget('AGE', 40),
      _getTitleItemWidget('POS', 40),
      _getTitleItemWidget('HT', 40),
      _getTitleItemWidget('WT', 60),
    ];
  }

  Future<void> getPlayers() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> returnedPlayers =
        await DataService().getBasketballPlayers();
    setState(() {
      players = returnedPlayers;
      isLoading = false;
      print('Returned players: $players');
    });
  }

  Future<String> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label,
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF001937))),
      width: width,
      height: 40,
      padding: EdgeInsets.fromLTRB(width == 200 ? 15 : 5, 0, 0, 0),
      alignment: width == 200 ? Alignment.centerLeft : Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        bool shouldReload = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AddBasketballPlayerPage(
                      isEditing: true,
                      playerData: players[index],
                    )));
        shouldReload ? getPlayers() : print('hey');
      },
      child: Container(
        child: Text(
          '${players[index]['fullName']}',
          style: TextStyle(
              color: Color(0xFF001937),
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        width: 100,
        height: 52,
        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            '#${players[index]['number']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 40,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${players[index]['age']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 40,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${(players[index]['position'].toString().split(' - '))[0]}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 40,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${players[index]['height']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 40,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${players[index]['weight']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: mainBGColor,
        body: !isLoading
            ? ListView(
                shrinkWrap: true,
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: mainBGColor,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: whiteColor,
                        ),
                      ),
                      title: Text(
                        'Roster',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      actions: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                bool shouldReload = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            AddBasketballPlayerPage()));
                                if (shouldReload) {
                                  getPlayers();
                                }
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/add_icon.png'),
                                        fit: BoxFit.contain)),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                Helper().showBottomSheet(
                                    context,
                                    'Choose team logo',
                                    'Choose image from library or take a new photo',
                                    [
                                      'Take new photo',
                                      'Choose from library'
                                    ],
                                    [
                                      () async {
                                        var image = await ImagePicker.pickImage(
                                            source: ImageSource.camera);
                                        // setState(() {
                                        //   currentSelectedImage =
                                        //       image;
                                        // });
                                        
                                        setState(() {
                                          isLoading = true;
                                        });
                                        Navigator.pop(context);
                                        String currentDate =
                                            DateTime.now().toString();
                                        String url = '';
                                        url = await _uploadFile(
                                            image, '${currentDate}');
                                        await DataService().updateCurrentUserData({'basketballPicUrl': url});
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      () async {
                                        var image = await ImagePicker.pickImage(
                                            source: ImageSource.gallery);
                                        // setState(() {
                                        //   currentSelectedImage =
                                        //       image;
                                        // });
                                        
                                        setState(() {
                                          isLoading = true;
                                        });
                                        Navigator.pop(context);
                                        String currentDate =
                                            DateTime.now().toString();
                                        String url = '';
                                        url = await _uploadFile(
                                            image, '${currentDate}');
                                        await DataService().updateCurrentUserData({'basketballPicUrl': url});
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    ]);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.camera_alt),
                                // decoration: BoxDecoration(
                                //     image: DecorationImage(
                                //         image:
                                //             AssetImage('assets/add_icon.png'),
                                //         fit: BoxFit.contain)),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                      // width: width,
                      height: height * 0.9,
                      decoration: BoxDecoration(color: whiteColor),
                      child: HorizontalDataTable(
                        leftHandSideColumnWidth: 200,
                        rightHandSideColumnWidth: 250,
                        isFixedHeader: true,
                        headerWidgets: _getTitleWidget(),
                        leftSideItemBuilder: _generateFirstColumnRow,
                        rightSideItemBuilder: _generateRightHandSideColumnRow,
                        itemCount: players.length,
                        rowSeparatorWidget: const Divider(
                          color: Colors.black12,
                          height: 2.0,
                          thickness: 0.0,
                        ),
                        leftHandSideColBackgroundColor: Color(0xFFDDE4EB),
                        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
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
