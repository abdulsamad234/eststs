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
import 'package:estats/pages/sign_up.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EnterYardsPage extends StatefulWidget {
  final String title;
  final String originalTitle;
  EnterYardsPage({this.title = 'Enter Yards', this.originalTitle});
  @override
  _EnterYardsPageState createState() => _EnterYardsPageState();
}

class _EnterYardsPageState extends State<EnterYardsPage> {
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // String currentNumber = '';
  bool isLoading = false;
  bool isDeleteEnabled = false;

  _buildNumbersButtons(index) {
    int realIndex1 = (index * 3);
    int realIndex2 = (index * 3 + 1);
    int realIndex3 = (index * 3 + 2);
    if (index == 3) {
      return Row(
        children: <Widget>[
          NumberCard(
            onTap: numberTapped,
            index: -5,
            childText: '',
          ),
          SizedBox(
            width: 15,
          ),
          NumberCard(
            onTap: numberTapped,
            index: 0,
            childText: '0',
          ),
          SizedBox(
            width: 15,
          ),
          NumberCard(
            onTap: numberTapped,
            index: isDeleteEnabled ? -1 : -5,
            childText: isDeleteEnabled ? '<' : '',
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          NumberCard(
            onTap: numberTapped,
            index: realIndex1 + 1,
            childText: '${realIndex1 + 1}',
          ),
          SizedBox(
            width: 15,
          ),
          NumberCard(
            onTap: numberTapped,
            index: realIndex2 + 1,
            childText: '${realIndex2 + 1}',
          ),
          SizedBox(
            width: 15,
          ),
          NumberCard(
            onTap: numberTapped,
            index: realIndex3 + 1,
            childText: '${realIndex3 + 1}',
          ),
        ],
      );
    }
  }

  numberTapped(int index) {
    String currentNumber = numberController.text;

    if (index == -5) {
      return;
    }
    if (index == -1) {
      currentNumber = currentNumber.substring(0, currentNumber.length - 1);
      setState(() {
        numberController.text = currentNumber;
      });
    } else {
      currentNumber = '$currentNumber$index';
      setState(() {
        numberController.text = currentNumber;
      });
    }

    if (currentNumber.length > 0) {
      setState(() {
        isDeleteEnabled = true;
      });
    } else {
      setState(() {
        isDeleteEnabled = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: <Widget>[
          Container(
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
                            '${widget.title}',
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
                        child: CustomTextBox(
                          keyboardType: TextInputType.number,
                          placeholderText: 'To',
                          enabled: false,
                          controller: numberController,
                          textboxBackgroundColor: Color(0xFFDDE4EB),
                          borderColor: Color(0xFFDDE4EB),
                          textColor: Color(0xFF000000),
                          placeholderColor: Color(0x33000000),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: List.generate(4, (index1) {
                            return Column(
                              children: <Widget>[
                                _buildNumbersButtons(index1),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                PlayerActionBottom(
                  actionType: widget.title,
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
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
