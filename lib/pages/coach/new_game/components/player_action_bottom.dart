import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/new_game/enter_yards_page.dart';
import 'package:estats/pages/coach/new_game/football_new_game.dart';
import 'package:estats/pages/coach/new_game/select_a_receiver_page.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class PlayerActionBottom extends StatefulWidget {
  final String actionType;
  final Player currentSelectedPlayer;
  final int opponentScore;
  final Map<String, dynamic> actionData;
  final Function changeSelectedPlayer;
  final int teamScore;
  final String gameId;
  final Function increaseScore;
  final Function deCreaseScore;
  final int yards;
  final Function setIsLoading;
  final String from;
  final List<Map<String, dynamic>> players;
  final List<Map<String, dynamic>> receiverPlayers;
  final bool isOffense;
  PlayerActionBottom(
      {@required this.actionType,
      this.currentSelectedPlayer,
      this.opponentScore,
      this.actionData,
      this.changeSelectedPlayer,
      this.teamScore,
      this.gameId,
      this.increaseScore,
      this.deCreaseScore,
      this.yards,
      this.setIsLoading,
      this.from,
      this.players,
      this.isOffense,
      this.receiverPlayers});

  @override
  _PlayerActionBottomState createState() => _PlayerActionBottomState();
}

class _PlayerActionBottomState extends State<PlayerActionBottom> {
  TextEditingController numberController = TextEditingController();

  int currentSelected = -1;
  Map<String, dynamic> actionData = Map<String, dynamic>();
  int originalNumber = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('team score here: ${widget.teamScore}');
    setState(() {
      actionData = widget.actionData;
    });
  }

  numberChanged(String newNumber) {
    widget.changeSelectedPlayer(newNumber);
    setState(() {
      actionData = widget.actionData;
    });
    print('Number from child: ${actionData['receiverNumber']}');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.actionType == 'Kick Returner') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
                if (!actionData.containsKey('playerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  if (currentSelected != -1) {
                    if (currentSelected == 0) {
                      setState(() {
                        actionData['type_of_return'] = 'KR';
                      });
                    } else {
                      setState(() {
                        actionData['type_of_return'] = 'PR';
                      });
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => EnterYardsPage(
                                  originalTitle: 'Kick Returner',
                                  actionData: actionData,
                                  teamScore: widget.teamScore,
                                  gameId: widget.gameId,
                                  from: 'Kick Returner',
                                )));
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => PopUp(
                        childWidget: Text(
                          'No fields can be left empty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                  }
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

    if (widget.actionType == 'Opponents Score Basketball') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
                print('hello');
                if (widget.opponentScore != null) {
                  Navigator.pop(context, widget.opponentScore);
                } else if (numberController.text != '') {
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

    if (widget.actionType == 'Opponents Score') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    borderColor: mainBGColor,
                    isSelected: currentSelected == 0,
                    onPressed: (context) {
                      setState(() {
                        currentSelected = currentSelected == 0 ? -1 : 0;
                      });
                    },
                    child: Text(
                      'My team Score',
                      style: TextStyle(
                          color:
                              currentSelected == 0 ? whiteColor : mainBGColor,
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
            CustomTextBox(
              onChanged: numberChanged,
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
                print('hello');
                if (widget.opponentScore != null) {
                  Navigator.pop(context, {
                    'score': widget.opponentScore,
                    'selected': currentSelected
                  });
                }
                //  else if (numberController.text != '') {
                //   int enteredScore = int.parse('${numberController.text}');
                //   Navigator.pop(context,
                //       {'score': enteredScore, 'selected': currentSelected});
                // }
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
            SizedBox(height: 10),
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
              onPressed: (context) async {
                setState(() {
                  actionData['timeAdded'] = DateTime.now();
                });
                if (currentSelected != -1) {
                  print('pressed: from: ${widget.yards}');

                  if (widget.from == 'Kick Returner') {
                    if (currentSelected == 0) {
                      widget.setIsLoading(true);
                      // await widget.deCreaseScore(widget.yards, widget.gameId);
                      setState(() {
                        actionData['yards'] = (0 - widget.yards);
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                  )),
                          (Route<dynamic> route) => false);
                    } else {
                      setState(() {
                        actionData['touchdown'] = 'TD';
                      });
                      widget.setIsLoading(true);
                      await widget.increaseScore(6, widget.gameId);
                      setState(() {
                        actionData['yards'] = (0 + widget.yards);
                        actionData['points'] = 6;
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                    amount: 6,
                                    scored: true,
                                  )),
                          (Route<dynamic> route) => false);
                    }
                  }

                  if (widget.from == 'Select a Passer') {
                    if (currentSelected == 0) {
                      widget.setIsLoading(true);
                      // await widget.deCreaseScore(widget.yards, widget.gameId);
                      setState(() {
                        actionData['yards'] = (0 - widget.yards);
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                  )),
                          (Route<dynamic> route) => false);
                    } else {
                      setState(() {
                        actionData['touchdown'] = 'TD';
                      });
                      widget.setIsLoading(true);
                      await widget.increaseScore(6, widget.gameId);
                      setState(() {
                        actionData['yards'] = (0 + widget.yards);
                        actionData['points'] = 6;
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                    amount: 6,
                                    scored: true,
                                  )),
                          (Route<dynamic> route) => false);
                    }
                  }

                  if (widget.from == 'Run') {
                    if (currentSelected == 0) {
                      widget.setIsLoading(true);
                      await widget.deCreaseScore(widget.yards, widget.gameId);
                      setState(() {
                        actionData['yards'] = (0 - widget.yards);
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                    amount: 0 - widget.yards,
                                    scored: true,
                                  )),
                          (Route<dynamic> route) => false);
                    } else {
                      setState(() {
                        actionData['touchdown'] = 'TD';
                      });
                      widget.setIsLoading(true);
                      await widget.increaseScore(6, widget.gameId);
                      setState(() {
                        actionData['yards'] = (0 + widget.yards);
                        actionData['points'] = 6;
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                    amount: 6,
                                    scored: true,
                                  )),
                          (Route<dynamic> route) => false);
                    }
                  }
                } else {
                  widget.setIsLoading(true);
                  setState(() {
                    actionData['yards'] = (0 + widget.yards);
                  });
                  String actionId =
                      await DataService().addAction(actionData, widget.gameId);
                  widget.setIsLoading(false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FootballNewGame(
                                actionId: actionId,
                              )),
                      (Route<dynamic> route) => false);
                  // showDialog(
                  //   context: context,
                  //   builder: (_) => PopUp(
                  //     childWidget: Text(
                  //       'Select Touchdown or Loss',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //           fontSize: 18, fontWeight: FontWeight.w700),
                  //     ),
                  //   ),
                  // );

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
    if (widget.actionType == 'Kick') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
                      'FG Missed',
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
              onPressed: (context) async {
                setState(() {
                  actionData['timeAdded'] = DateTime.now();
                });
                // signUp(context);
                if (!actionData.containsKey('playerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  if (currentSelected != -1) {
                    if (currentSelected == 0) {
                      setState(() {
                        actionData['kick_status'] = 'fg_made';
                      });
                      widget.setIsLoading(true);
                      await widget.increaseScore(3, widget.gameId);
                      setState(() {
                        actionData['points'] = 3;
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                    scored: true,
                                    amount: actionData['points'],
                                  )),
                          (Route<dynamic> route) => false);
                    } else if (currentSelected == 1) {
                      setState(() {
                        actionData['kick_status'] = 'fg_missed';
                      });
                      widget.setIsLoading(true);
                      // await widget.increaseScore(3, widget.gameId);
                      // setState(() {
                      //   actionData['points'] = 3;
                      // });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                  )),
                          (Route<dynamic> route) => false);
                    } else if (currentSelected == 2) {
                      setState(() {
                        actionData['kick_status'] = 'xp_made';
                      });
                      widget.setIsLoading(true);
                      await widget.increaseScore(1, widget.gameId);
                      setState(() {
                        actionData['points'] = 1;
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                    scored: true,
                                    amount: actionData['points'],
                                  )),
                          (Route<dynamic> route) => false);
                    } else if (currentSelected == 3) {
                      setState(() {
                        actionData['kick_status'] = 'xp_missed';
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                  )),
                          (Route<dynamic> route) => false);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => PopUp(
                        childWidget: Text(
                          'Please choose a kick status',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                  }
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

    if (widget.actionType == 'Select a Receiver') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
              onPressed: (context) async {
                if (!actionData.containsKey('receiverNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Receiver',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EnterYardsPage(
                              originalTitle: 'Select a Passer',
                              actionData: actionData,
                              from: 'Select a Receiver',
                              gameId: widget.gameId,
                              teamScore: widget.teamScore)));
                }
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
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
              onPressed: (context) async {
                if (!actionData.containsKey('returnerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  setState(() {
                    actionData['timeAdded'] = DateTime.now();
                    actionData['touchdown'] = 'DTD';
                  });
                  widget.setIsLoading(true);
                  widget.increaseScore(6, widget.gameId);
                  String actionId =
                      await DataService().addAction(actionData, widget.gameId);
                  widget.setIsLoading(false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FootballNewGame(
                                actionId: actionId,
                                scored: true,
                                amount: 6,
                              )),
                      (Route<dynamic> route) => false);
                }
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
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
                if (!actionData.containsKey('playerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EnterYardsPage(
                                originalTitle: 'Run',
                                actionData: actionData,
                                teamScore: widget.teamScore,
                                gameId: widget.gameId,
                                from: 'Run',
                              )));
                  // if (currentSelected != -1) {
                  //   print('pressed: from: ${widget.yards}');
                  //   setState(() {});
                  //   if (currentSelected == 0) {
                  //     widget.setIsLoading(true);
                  //     setState(() {
                  //       actionData['status'] = 'incomplete';
                  //     });
                  //     await DataService().addAction(actionData, widget.gameId);
                  //     widget.setIsLoading(false);
                  //     Navigator.of(context).popUntil((route) => route.isFirst);
                  //   } else {
                  //     setState(() {
                  //       actionData['status'] = 'intercepted';
                  //     });
                  //     widget.setIsLoading(true);
                  //     await DataService().addAction(actionData, widget.gameId);
                  //     widget.setIsLoading(false);
                  //     Navigator.popUntil(context, (route) => route.isFirst);
                  //   }
                  // } else {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (BuildContext context) =>
                  //               SelectReceiverPage(
                  //                 originalTitle: 'Select a Passer',
                  //                 title: 'Select a Receiver',
                  //                 gameId: widget.gameId,
                  //                 isOffense: widget.isOffense,
                  //                 players: widget.players,
                  //                 teamScore: widget.teamScore,
                  //                 actionData: actionData,
                  //                 increaseScore: widget.increaseScore,
                  //                 decreaseScore: widget.deCreaseScore,
                  //               )));
                  // }
                }
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
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
              onPressed: (context) async {
                setState(() {
                  actionData['timeAdded'] = DateTime.now();
                });
                // signUp(context);
                if (!actionData.containsKey('playerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  if (currentSelected != -1) {
                    print('pressed: from: ${widget.yards}');
                    setState(() {});
                    if (currentSelected == 0) {
                      widget.setIsLoading(true);
                      setState(() {
                        actionData['status'] = 'incomplete';
                      });
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                  )),
                          (Route<dynamic> route) => false);
                    } else {
                      setState(() {
                        actionData['status'] = 'intercepted';
                      });
                      widget.setIsLoading(true);
                      String actionId = await DataService()
                          .addAction(actionData, widget.gameId);
                      widget.setIsLoading(false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FootballNewGame(
                                    actionId: actionId,
                                  )),
                          (Route<dynamic> route) => false);
                    }
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SelectReceiverPage(
                                  originalTitle: 'Select a Passer',
                                  title: 'Select a Receiver',
                                  gameId: widget.gameId,
                                  isOffense: widget.isOffense,
                                  players: widget.receiverPlayers,
                                  teamScore: widget.teamScore,
                                  actionData: actionData,
                                  increaseScore: widget.increaseScore,
                                  decreaseScore: widget.deCreaseScore,
                                )));
                  }
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

    if (widget.actionType == 'Tackle by') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
              onPressed: (context) async {
                // signUp(context);
                setState(() {
                  actionData['timeAdded'] = DateTime.now();
                });
                // signUp(context);
                if (!actionData.containsKey('playerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  widget.setIsLoading(true);
                  String actionId =
                      await DataService().addAction(actionData, widget.gameId);
                  widget.setIsLoading(false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FootballNewGame(
                                actionId: actionId,
                              )),
                      (Route<dynamic> route) => false);
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
    if (widget.actionType == 'Sack by') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
              onPressed: (context) async {
                // signUp(context);
                setState(() {
                  actionData['timeAdded'] = DateTime.now();
                });
                // signUp(context);
                if (!actionData.containsKey('playerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  widget.setIsLoading(true);
                  String actionId =
                      await DataService().addAction(actionData, widget.gameId);
                  widget.setIsLoading(false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FootballNewGame(
                                actionId: actionId,
                              )),
                      (Route<dynamic> route) => false);
                }
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
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
              onPressed: (context) async {
                // signUp(context);
                setState(() {
                  actionData['timeAdded'] = DateTime.now();
                });
                // signUp(context);
                if (!actionData.containsKey('playerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  if (currentSelected == -1) {
                  } else {
                    setState(() {
                      actionData['touchdown'] = 'DTD';
                    });
                    await widget.increaseScore(6, widget.gameId);
                  }
                  widget.setIsLoading(true);
                  String actionId =
                      await DataService().addAction(actionData, widget.gameId);
                  widget.setIsLoading(false);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FootballNewGame(
                                actionId: actionId,
                                scored: true,
                                amount: 6,
                              )),
                      (Route<dynamic> route) => false);
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
    if (widget.actionType == 'Forced Fumble') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
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
              onChanged: numberChanged,
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
              onPressed: (context) async {
                // signUp(context);
                if (!actionData.containsKey('playerNumber')) {
                  showDialog(
                    context: context,
                    builder: (_) => PopUp(
                      childWidget: Text(
                        'Please choose a Player',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                } else {
                  if (currentSelected == -1) {
                    setState(() {
                      actionData['timeAdded'] = DateTime.now();
                    });
                    widget.setIsLoading(true);
                    String actionId = await DataService()
                        .addAction(actionData, widget.gameId);
                    widget.setIsLoading(false);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FootballNewGame(
                                  actionId: actionId,
                                )),
                        (Route<dynamic> route) => false);
                  } else {
                    setState(() {
                      actionData['touchdown'] = 'DTD';
                    });
                    print(
                        'Receiver players in bottom: ${widget.receiverPlayers}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SelectReceiverPage(
                                  originalTitle: 'Forced Fumble',
                                  title: 'Return Touchdown by',
                                  actionData: actionData,
                                  decreaseScore: widget.deCreaseScore,
                                  increaseScore: widget.increaseScore,
                                  players: widget.receiverPlayers,
                                  teamScore: widget.teamScore,
                                  gameId: widget.gameId,
                                )));
                  }
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
    return Container();
  }
}
