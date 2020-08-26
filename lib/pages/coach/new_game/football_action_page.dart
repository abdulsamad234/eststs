import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/components/player_action_bottom.dart';
import 'package:estats/pages/coach/new_game/components/player_action_card.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FootballActionPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> players;
  final List<Map<String, dynamic>> receiverPlayers;
  final String gameId;
  final String originalText;
  final bool isOffense;
  final int teamScore;
  FootballActionPage(
      {this.title = 'Kick Returner',
      this.players,
      this.gameId,
      this.teamScore,
      this.isOffense = false,
      this.originalText,
      this.receiverPlayers});
  @override
  _FootballActionPageState createState() => _FootballActionPageState();
}

class _FootballActionPageState extends State<FootballActionPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  int quarterNumber = 1;
  int firstTeamScore = 0;
  int secondTeamScore = 0;
  int numberOfPlayers = 12;
  int currentPlayerNumber = 0;
  List<Player> initialSix = List<Player>();
  Player currentSelectedPlayer;
  Map<String, dynamic> actionData = Map<String, dynamic>();
  List<bool> playersSelected = List<bool>();

  

  getPlayers() {
    print('Number of players on action page: ${widget.players.length}');
    for (int i = 0; i < widget.players.length; i++) {
      if (i < 12) {
        setState(() {
          initialSix.add(Player(
              firstName: widget.players[i]['fullName'].toString().split(' ')[0],
              lastName:
                  widget.players[i]['fullName'].toString().split(' ').length > 1
                      ? widget.players[i]['fullName'].toString().split(' ')[1]
                      : '',
              number: widget.players[i]['number']));
        });
      }
    }
    for (int i = 0; i < numberOfPlayers; i++) {
      playersSelected.add(false);
    }
  }

  setIsLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  _buildInitial(index) {
    print("Initial six: $initialSix");
    return Row(
      children: <Widget>[
        PlayerActionCard(
          isSelected: playersSelected[(index * 3)],
          onTap: selectPlayerButton,
          index: (index * 3),
          player:
              (index * 3) < initialSix.length ? initialSix[(index * 3)] : null,
        ),
        SizedBox(
          width: 15,
        ),
        PlayerActionCard(
          isSelected: playersSelected[(index * 3 + 1)],
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
          isSelected: playersSelected[(index * 3 + 2)],
          onTap: selectPlayerButton,
          index: (index * 3 + 2),
          player: (index * 3 + 2) < initialSix.length
              ? initialSix[(index * 3 + 2)]
              : null,
        )
      ],
    );
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

  decreaseTeamScore(int by, String gameId) async {
    if (by <= widget.teamScore) {
      int newScore = widget.teamScore - by;
      await DataService().updateCurrentGame({'teamPoint': newScore}, gameId);
    }
  }

  increaseTeamScore(int by, String gameId) async {
    int newScore = widget.teamScore + by;
    await DataService().updateCurrentGame({'teamPoint': newScore}, gameId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlayers();
    setState(() {
      actionData.addAll({'gameId': widget.gameId});
      actionData['action_type'] = widget.originalText;
      actionData['is_offense'] = widget.isOffense;
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
                PlayerActionBottom(
                  actionType: widget.title,
                  actionData: actionData,
                  changeSelectedPlayer: onChangeText,
                  teamScore: widget.teamScore,
                  gameId: widget.gameId,
                  setIsLoading: setIsLoading,
                  players: widget.players,
                  receiverPlayers: widget.receiverPlayers,
                  isOffense: widget.isOffense,
                  increaseScore: increaseTeamScore,
                  deCreaseScore: decreaseTeamScore,
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
