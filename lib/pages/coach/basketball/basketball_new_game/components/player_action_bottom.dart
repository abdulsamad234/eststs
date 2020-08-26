import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/new_game/enter_yards_page.dart';
import 'package:estats/pages/coach/new_game/select_a_receiver_page.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class PlayerActionBottom extends StatefulWidget {
  final String actionType;
  final Player currentSelectedPlayer;
  final int opponentScore;
  PlayerActionBottom({@required this.actionType, this.currentSelectedPlayer, this.opponentScore});

  @override
  _PlayerActionBottomState createState() => _PlayerActionBottomState();
}

class _PlayerActionBottomState extends State<PlayerActionBottom> {
  TextEditingController numberController = TextEditingController();

  int currentSelected = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.actionType == 'Kick Returner') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    borderColor: mainBGColor,
                    isSelected: currentSelected == 0,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 0;
                      });
                    },
                    child: Text(
                      'Kick Return',
                      style: TextStyle(
                          color:
                              currentSelected == 0 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SecondaryButton(
                    isSelected: currentSelected == 1,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 1;
                      });
                    },
                    borderColor: mainBGColor,
                    child: Text(
                      'Punt Return',
                      style: TextStyle(
                          color:
                              currentSelected == 1 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => EnterYardsPage(
                              originalTitle: 'Kick Returner',
                            )));
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Complete',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.actionType == 'Opponents Score') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('MANUAL SCORE',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => EnterYardsPage(
                //               originalTitle: 'Kick Returner',
                //             )));
                if(widget.opponentScore != null){
                  Navigator.pop(context, widget.opponentScore);
                }
                else if(numberController.text != ''){
                  int enteredScore = int.parse('${numberController.text}');
                  Navigator.pop(context, enteredScore);
                }
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Complete',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.actionType == 'Enter Yards') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    borderColor: mainBGColor,
                    isSelected: currentSelected == 0,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 0;
                      });
                    },
                    child: Text(
                      'Loss',
                      style: TextStyle(
                          color:
                              currentSelected == 0 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SecondaryButton(
                    isSelected: currentSelected == 1,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 1;
                      });
                    },
                    borderColor: mainBGColor,
                    child: Text(
                      'Touchdown',
                      style: TextStyle(
                          color:
                              currentSelected == 1 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                // signUp(context);
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Complete',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
    if (widget.actionType == 'Kick') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    borderColor: mainBGColor,
                    isSelected: currentSelected == 0,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 0;
                      });
                    },
                    child: Text(
                      'FG made',
                      style: TextStyle(
                          color:
                              currentSelected == 0 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SecondaryButton(
                    isSelected: currentSelected == 1,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 1;
                      });
                    },
                    borderColor: mainBGColor,
                    child: Text(
                      'Punt Return',
                      style: TextStyle(
                          color:
                              currentSelected == 1 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    borderColor: mainBGColor,
                    isSelected: currentSelected == 2,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 2;
                      });
                    },
                    child: Text(
                      'XP made',
                      style: TextStyle(
                          color:
                              currentSelected == 2 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SecondaryButton(
                    isSelected: currentSelected == 3,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 3;
                      });
                    },
                    borderColor: mainBGColor,
                    child: Text(
                      'XP missed',
                      style: TextStyle(
                          color:
                              currentSelected == 3 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                // signUp(context);
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Complete',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.actionType == 'Select a Receiver') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => EnterYardsPage(
                              originalTitle: 'Select a Passer',
                            )));
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Confirm',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.actionType == 'Return Touchdown by') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                // signUp(context);
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Confirm',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.actionType == 'Run') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => EnterYardsPage(
                              originalTitle: 'Run',
                            )));
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Confirm',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
    if (widget.actionType == 'Select a Passer') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    borderColor: mainBGColor,
                    isSelected: currentSelected == 0,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 0;
                      });
                    },
                    child: Text(
                      'Incomplete',
                      style: TextStyle(
                          color:
                              currentSelected == 0 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SecondaryButton(
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 1;
                      });
                    },
                    isSelected: currentSelected == 1,
                    borderColor: mainBGColor,
                    child: Text(
                      'Interception',
                      style: TextStyle(
                          color:
                              currentSelected == 1 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                // signUp(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SelectReceiverPage(
                              originalTitle: 'Select a Passer',
                              title: 'Select a Receiver',
                            )));
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Complete',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
    if (widget.actionType == 'Tackle by') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                // signUp(context);
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Complete',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
    if (widget.actionType == 'Sack by') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                // signUp(context);
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Confirm',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
    if (widget.actionType == 'Interception') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    borderColor: mainBGColor,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 1;
                      });
                    },
                    isSelected: currentSelected == 1,
                    child: Text(
                      'Touchdown',
                      style: TextStyle(
                          color:
                              currentSelected == 1 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                // signUp(context);
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Complete',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
    if (widget.actionType == 'Forced Fumble') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('OTHER PLAYER',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextBox(
              keyboardType: TextInputType.number,
              placeholderText: 'Enter Number',
              controller: numberController,
              textboxBackgroundColor: Color(0xFFDDE4EB),
              borderColor: Color(0xFFDDE4EB),
              textColor: Color(0xFF000000),
              placeholderColor: Color(0x33000000),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    borderColor: mainBGColor,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = 1;
                      });
                    },
                    isSelected: currentSelected == 1,
                    child: Text(
                      'Touchdown',
                      style: TextStyle(
                          color:
                              currentSelected == 1 ? whiteColor : mainBGColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: (context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SelectReceiverPage(
                              originalTitle: 'Forced Fumble',
                              title: 'Return Touchdown by',
                            )));
              },
              bgColor: Color(0xFF004381),
              child: Text(
                'Complete',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
