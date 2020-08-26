import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/basketball/basketball_new_game/basketball_new_game.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/components/player_action_bottom.dart';
import 'package:estats/pages/coach/new_game/components/player_action_card.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BasketballActionPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> players;
  final int pointMissed;
  final int pointScored;
  final Function increaseScore;
  final String currentGameId;
  final Map<String, dynamic> actionData;
  BasketballActionPage(
      {this.title = 'Kick Returner',
      this.players,
      this.pointMissed,
      this.pointScored,
      this.increaseScore,
      this.currentGameId,
      this.actionData});
  @override
  _BasketballActionPageState createState() => _BasketballActionPageState();
}

class _BasketballActionPageState extends State<BasketballActionPage> {
  TextEditingController numberController = TextEditingController();
  bool isLoading = false;
  int quarterNumber = 1;
  int firstTeamScore = 0;
  int secondTeamScore = 0;
  List<Player> initialSix = List<Player>();
  int currentPlayerNumber = 0;
  Player currentSelectedPlayer;
  List<bool> playersSelected = List<bool>();
  Map<String, dynamic> actionData;
  int currentSelected = -1;

  getPlayers() {
    // print('players here: ${widget.players}');
    for (int i = 0; i < widget.players.length; i++) {
      // if (i < 6) {
      setState(() {
        initialSix.add(Player(
            firstName: widget.players[i]['fullName'].toString().split(' ')[0],
            lastName:
                widget.players[i]['fullName'].toString().split(' ').length > 1
                    ? widget.players[i]['fullName'].toString().split(' ')[1]
                    : '',
            number: widget.players[i]['number']));
        playersSelected.add(false);
      });
      // }
    }
  }

  _buildInitial(index) {
    print("Initial six: $initialSix");
    return Row(
      children: <Widget>[
        PlayerActionCard(
          isSelected: (index * 3) < playersSelected.length
              ? playersSelected[(index * 3)]
              : false,
          onTap: selectPlayerButton,
          index: (index * 3),
          player:
              (index * 3) < initialSix.length ? initialSix[(index * 3)] : null,
        ),
        SizedBox(
          width: 15,
        ),
        PlayerActionCard(
          isSelected: (index * 3 + 1) < playersSelected.length
              ? playersSelected[(index * 3 + 1)]
              : false,
          onTap: selectPlayerButton,
          index: (index * 3 + 1),
          player: (index * 3 + 1) < initialSix.length
              ? initialSix[(index * 3 + 1)]
              : null,
        ),
        SizedBox(
          width: 15,
        ),
        PlayerActionCard(
          isSelected: (index * 3 + 2) < playersSelected.length
              ? playersSelected[(index * 3 + 2)]
              : false,
          onTap: selectPlayerButton,
          index: (index * 3 + 2),
          player: (index * 3 + 2) < initialSix.length
              ? initialSix[(index * 3 + 2)]
              : null,
        )
      ],
    );
  }

  // selectPlayerButton(int index) {
  //   if (index < initialSix.length) {
  //     for (int i = 0; i < playersSelected.length; i++) {
  //       setState(() {
  //         playersSelected[i] = false;
  //       });
  //     }
  //     setState(() {
  //       playersSelected[index] = true;
  //       currentSelectedPlayer = initialSix[index];
  //     });
  //   }
  // }

  completePressed() async {
    setState(() {
      actionData['timeAdded'] = DateTime.now();
    });
    print('Action data now: $actionData');
    setState(() {
      isLoading = true;
    });
    if (widget.title == 'Rebound' && currentSelected == -1) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => PopUp(
          childWidget: Text(
            'Please choose defensive or offensive rebound',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      );
      return;
    }
    if (!actionData.containsKey('playerNumber')) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => PopUp(
          childWidget: Text(
            'Please choose a Player',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      );
    } else {
      bool scored = false;
      if (widget.title == 'Score' && widget.actionData.containsKey('status')) {
        print('Status: ${widget.actionData['status']}');
        if (widget.actionData['status'] == 'made') {
          scored = true;
          await widget.increaseScore(widget.pointScored, widget.currentGameId);
        }
      }
      if (widget.title == 'Rebound') {
        setState(() {
          actionData['rebound_type'] =
              currentSelected == 0 ? 'offensive' : 'defensive';
        });
      }
      String actionId = await DataService()
          .addBasketballAction(actionData, widget.currentGameId);
      setState(() {
        isLoading = false;
      });
      if (!scored)
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BasketballNewGame(
                      actionId: actionId,
                    )),
            (Route<dynamic> route) => false);
      else
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BasketballNewGame(
                      actionId: actionId,
                      amount: widget.pointScored,
                      scored: true,
                    )),
            (Route<dynamic> route) => false);
    }
  }

  onChangeText(String newText) {
    if (newText == '') {
      currentSelectedPlayer == null
          ? setState(() {
              actionData.removeWhere((key, value) {
                return key == 'playerNumber';
              });
            })
          : setState(() {
              actionData['playerNumber'] = currentSelectedPlayer.number;
            });
    } else {
      setState(() {
        actionData['playerNumber'] = int.parse(newText);
      });
    }
    print('Player number from master: ${actionData['playerNumber']}');
  }

  selectPlayerButton(int index) {
    if (index < initialSix.length) {
      for (int i = 0; i < playersSelected.length; i++) {
        setState(() {
          playersSelected[i] = false;
        });
      }
      setState(() {
        playersSelected[index] = true;
        currentSelectedPlayer = initialSix[index];
        actionData['playerNumber'] = currentSelectedPlayer.number;
        currentPlayerNumber = currentSelectedPlayer.number;
        print('action player number: ${actionData['playerNumber']}');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlayers();
    setState(() {
      actionData = widget.actionData;
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: List.generate(4, (index1) {
                            return Column(
                              children: <Widget>[
                                _buildInitial(index1),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
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
                        onChanged: onChangeText,
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
                      widget.title == 'Rebound'
                          ? Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          'Offensive',
                                          style: TextStyle(
                                              color: currentSelected == 0
                                                  ? whiteColor
                                                  : mainBGColor,
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
                                          'Defensive',
                                          style: TextStyle(
                                              color: currentSelected == 1
                                                  ? whiteColor
                                                  : mainBGColor,
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
                              ],
                            )
                          : Container(),
                      PrimaryButton(
                        onPressed: (context) async {
                          await completePressed();
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
