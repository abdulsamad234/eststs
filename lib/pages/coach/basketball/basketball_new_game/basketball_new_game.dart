import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/basketball/basketball_new_game/basketball_action_page.dart';
import 'package:estats/pages/coach/basketball/basketball_new_game/basketball_opponents_score_page.dart';
import 'package:estats/pages/coach/basketball/basketball_new_game/components/basketball_game_action_card.dart';
import 'package:estats/pages/coach/basketball/basketball_new_game/components/basketball_point_action_card.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/end_game_page.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/opponents_score_page.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BasketballNewGame extends StatefulWidget {
  final String actionId;
  final bool scored;
  final int amount;
  BasketballNewGame({this.actionId = '', this.scored = false, this.amount = 0});
  @override
  _BasketballNewGameState createState() => _BasketballNewGameState();
}

class _BasketballNewGameState extends State<BasketballNewGame> {
  TextEditingController team1Controller = TextEditingController();
  TextEditingController team2Controller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  int quarterNumber = 1;
  int firstTeamScore = 0;
  int secondTeamScore = 0;
  bool isOnBreak = false;
  Map<String, dynamic> userData;
  Map<String, dynamic> gameData;
  String teamName;
  String currentGameId = '';
  bool undoEnabled = false;
  Map<String, dynamic> undoData = Map<String, dynamic>();
  String secondTeamName;
  List<Map<String, dynamic>> players = List<Map<String, dynamic>>();

  Future getUserInfo() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> newUserData = await DataService().getCurrentUserData();
    //create new game
    String returnedGameId =
        await DataService().createNewGameOrGetCurrentBasketballGame();
    List<Map<String, dynamic>> returnedPlayers =
        await DataService().getBasketballPlayers();
    setState(() {
      currentGameId = returnedGameId;
      players = returnedPlayers;
      print('players returned: $players');
      print('Game id: $currentGameId');
      userData = newUserData;
      isLoading = false;
      teamName = userData.containsKey('teamName') ? userData['teamName'] : '';
      team1Controller.text = teamName;
    });
  }

  undo() async {
    getGameInfo().then((nothing) {
      gameData.remove('endTime');
      gameData.remove('${quarterNumber}QuarterEnd');
      setState(() {
        isLoading = true;
      });
      DataService()
          .setBasketballCurrentGame(gameData, currentGameId)
          .then((nothing) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  endGame() async {
    if (isOnBreak) {
      //is on break don't add quarter end
      DateTime nowDate = DateTime.now();
      await DataService()
          .updateCurrentBasketballGame({'endTime': nowDate}, currentGameId);
    } else {
      //end quarter
      DateTime nowDate = DateTime.now();
      await DataService().updateCurrentBasketballGame(
          {'endTime': nowDate, '${quarterNumber}QuarterEnd': nowDate},
          currentGameId);
    }
  }

  Future<void> getGameInfo() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> newGameData =
        await DataService().getCurrentBasketballGame(currentGameId);
    print('New game data here: $newGameData');
    setState(() {
      gameData = newGameData;
      isLoading = false;
      team2Controller.text =
          gameData.containsKey('opponentName') ? gameData['opponentName'] : '';
      firstTeamScore =
          gameData.containsKey('teamPoint') ? gameData['teamPoint'] : 0;
      secondTeamScore =
          gameData.containsKey('opponentPoint') ? gameData['opponentPoint'] : 1;
      quarterNumber = gameData.containsKey('currentQuarter')
          ? gameData['currentQuarter']
          : 0;
    });
  }

  increaseOpponentScore(int by, String gameId) {
    setState(() {
      secondTeamScore += by;
    });
    DataService().updateCurrentBasketballGame(
        {'opponentPoint': secondTeamScore}, gameId);
    setState(() {
      undoEnabled = true;
      undoData['type'] = 'opponent_score';
      undoData['amount'] = by;
    });
  }

  increaseTeamScore(int by, String gameId) async {
    print('Increasing score...');
    //choose player who scored
    setState(() {
      firstTeamScore += by;
    });
    DataService()
        .updateCurrentBasketballGame({'teamPoint': firstTeamScore}, gameId);
  }

  onChangedTeam2Name(String newOpponentName) {
    DataService().updateCurrentBasketballGame(
        {'opponentName': team2Controller.text}, currentGameId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo().then((nothing) {
      getGameInfo();
    });
    if (widget.actionId != '') {
      setState(() {
        undoEnabled = true;
      });
      setState(() {
        undoData['actionId'] = widget.actionId;
      });
      if (widget.scored) {
        setState(() {
          undoData['type'] = 'action_and_score';
          undoData['amount'] = widget.amount;
        });
      } else {
        setState(() {
          undoData['type'] = 'just_action';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: mainBGColor,
        body: !isLoading
            ? Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        // mainAxisSize: MainAxisSize.max,
                        padding: EdgeInsets.all(0),
                        children: <Widget>[
                          Container(
                            height: height * 0.3,
                            decoration: BoxDecoration(color: mainBGColor),
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.15,
                                vertical: height * 0.05),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    // width: width,
                                    // decoration: BoxDecoration(color: Colors.red),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          team1Controller,
                                                      enabled: false,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration: InputDecoration(
                                                          hintText: 'Team 1...',
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.4),
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          border:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.15,
                                                  ),
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          team2Controller,
                                                      onChanged: (newVal) {
                                                        onChangedTeam2Name(
                                                            newVal);
                                                        // team2Controller.text =
                                                        //     newVal;
                                                      },
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration: InputDecoration(
                                                          hintText: 'Team 2...',
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.4),
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          border:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Text(
                                                    '$firstTeamScore',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '-',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '$secondTeamScore',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            isOnBreak
                                                ? (quarterNumber % 10 == 1 &&
                                                        quarterNumber % 100 !=
                                                            11
                                                    ? '${quarterNumber}st QTR break'
                                                    : quarterNumber % 10 == 2 &&
                                                            quarterNumber %
                                                                    100 !=
                                                                12
                                                        ? '${quarterNumber}nd QTR break'
                                                        : quarterNumber % 10 ==
                                                                    3 &&
                                                                quarterNumber %
                                                                        100 !=
                                                                    13
                                                            ? '${quarterNumber}rd QTR break'
                                                            : '${quarterNumber}th QTR break')
                                                : (quarterNumber % 10 == 1 &&
                                                        quarterNumber % 100 !=
                                                            11
                                                    ? '${quarterNumber}st QTR'
                                                    : quarterNumber % 10 == 2 &&
                                                            quarterNumber %
                                                                    100 !=
                                                                12
                                                        ? '${quarterNumber}nd QTR'
                                                        : quarterNumber % 10 ==
                                                                    3 &&
                                                                quarterNumber %
                                                                        100 !=
                                                                    13
                                                            ? '${quarterNumber}rd QTR'
                                                            : '${quarterNumber}th QTR'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // height: height * 0.7,
                            padding:
                                EdgeInsets.only(top: 30, right: 30, left: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      BasketballGamePointCard(
                                          point: 2,
                                          isOnBreak: isOnBreak,
                                          players: players,
                                          isOpponent: false,
                                          onPressed: () {
                                            // increaseTeamScore(2, currentGameId);
                                            Map<String, dynamic> actionData = {
                                              'action_type': 'Score',
                                              'status': 'made',
                                              'gameId': currentGameId,
                                              'points': 2
                                            };

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BasketballActionPage(
                                                          title: 'Score',
                                                          players: players,
                                                          pointScored: 2,
                                                          increaseScore:
                                                              increaseTeamScore,
                                                          currentGameId:
                                                              currentGameId,
                                                          actionData:
                                                              actionData,
                                                        )));
                                          }),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      BasketballGamePointCard(
                                          point: 2,
                                          isOnBreak: isOnBreak,
                                          players: players,
                                          isOpponent: true,
                                          onPressed: () {
                                            Map<String, dynamic> actionData = {
                                              'action_type': 'Score',
                                              'status': 'missed',
                                              'gameId': currentGameId,
                                              'points': 2
                                            };
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BasketballActionPage(
                                                          title: 'Missed',
                                                          players: players,
                                                          pointMissed: 2,
                                                          actionData:
                                                              actionData,
                                                          currentGameId:
                                                              currentGameId,
                                                        )));
                                          }),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      BasketballGamePointCard(
                                          point: 3,
                                          isOnBreak: isOnBreak,
                                          players: players,
                                          isOpponent: false,
                                          onPressed: () {
                                            // increaseTeamScore(3, currentGameId);
                                            Map<String, dynamic> actionData = {
                                              'action_type': 'Score',
                                              'status': 'made',
                                              'gameId': currentGameId,
                                              'points': 3
                                            };
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BasketballActionPage(
                                                          title: 'Score',
                                                          players: players,
                                                          pointScored: 3,
                                                          increaseScore:
                                                              increaseTeamScore,
                                                          currentGameId:
                                                              currentGameId,
                                                          actionData:
                                                              actionData,
                                                        )));
                                          }),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      BasketballGamePointCard(
                                          point: 3,
                                          isOnBreak: isOnBreak,
                                          players: players,
                                          isOpponent: true,
                                          onPressed: () {
                                            // increaseOpponentScore(
                                            //     3, currentGameId);
                                            Map<String, dynamic> actionData = {
                                              'action_type': 'Score',
                                              'status': 'missed',
                                              'gameId': currentGameId,
                                              'points': 3
                                            };
                                            print(
                                                'Players before sending: $players');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BasketballActionPage(
                                                          title: 'Missed',
                                                          players: players,
                                                          pointMissed: 3,
                                                          actionData:
                                                              actionData,
                                                          currentGameId:
                                                              currentGameId,
                                                        )));
                                          }),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      BasketballGamePointCard(
                                          point: 1,
                                          isOnBreak: isOnBreak,
                                          players: players,
                                          isOpponent: false,
                                          onPressed: () {
                                            // increaseTeamScore(1, currentGameId);
                                            Map<String, dynamic> actionData = {
                                              'action_type': 'Score',
                                              'status': 'made',
                                              'gameId': currentGameId,
                                              'points': 1
                                            };
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BasketballActionPage(
                                                          title: 'Score',
                                                          players: players,
                                                          pointScored: 1,
                                                          increaseScore:
                                                              increaseTeamScore,
                                                          currentGameId:
                                                              currentGameId,
                                                          actionData:
                                                              actionData,
                                                        )));
                                          }),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      BasketballGamePointCard(
                                          point: 1,
                                          isOnBreak: isOnBreak,
                                          players: players,
                                          isOpponent: true,
                                          onPressed: () {
                                            Map<String, dynamic> actionData = {
                                              'action_type': 'Score',
                                              'status': 'missed',
                                              'gameId': currentGameId,
                                              'points': 1
                                            };
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BasketballActionPage(
                                                          title: 'Missed',
                                                          players: players,
                                                          pointMissed: 1,
                                                          actionData:
                                                              actionData,
                                                          currentGameId:
                                                              currentGameId,
                                                        )));
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // height: height * 0.7,
                            padding:
                                EdgeInsets.only(top: 30, right: 30, left: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      BasketballGameActionCard(
                                        currentGameId: currentGameId,
                                        text: 'Assist',
                                        isOnBreak: isOnBreak,
                                        players: players,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      BasketballGameActionCard(
                                        currentGameId: currentGameId,
                                        text: 'Steal',
                                        isOnBreak: isOnBreak,
                                        players: players,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      BasketballGameActionCard(
                                        currentGameId: currentGameId,
                                        text: 'Foul',
                                        isOnBreak: isOnBreak,
                                        players: players,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      BasketballGameActionCard(
                                        currentGameId: currentGameId,
                                        text: 'Rebound',
                                        isOnBreak: isOnBreak,
                                        players: players,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      BasketballGameActionCard(
                                        currentGameId: currentGameId,
                                        text: 'Block',
                                        isOnBreak: isOnBreak,
                                        players: players,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      BasketballGameActionCard(
                                        currentGameId: currentGameId,
                                        text: 'Turnover',
                                        isOnBreak: isOnBreak,
                                        players: players,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: height * 0.15,
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  if (undoEnabled) {
                                    if (undoData.containsKey('type')) {
                                      if (undoData['type'] ==
                                          'opponent_score') {
                                        setState(() {
                                          secondTeamScore -= undoData['amount'];
                                        });
                                        DataService()
                                            .updateCurrentBasketballGame({
                                          'opponentPoint': secondTeamScore
                                        }, currentGameId);
                                      } else if (undoData['type'] ==
                                          'action_and_score') {
                                        setState(() {
                                          firstTeamScore -= undoData['amount'];
                                        });
                                        DataService()
                                            .updateCurrentBasketballGame(
                                                {'teamPoint': firstTeamScore},
                                                currentGameId);
                                        DataService().deleteBasketballAction(
                                            undoData['actionId'],
                                            currentGameId);
                                      } else if (undoData['type'] ==
                                          'just_action') {
                                        DataService().deleteBasketballAction(
                                            undoData['actionId'],
                                            currentGameId);
                                        showDialog(
                                          context: context,
                                          builder: (_) => PopUp(
                                            childWidget: Text(
                                              'Undo Completed 👍',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    setState(() {
                                      undoEnabled = false;
                                      undoData = Map<String, dynamic>();
                                    });
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.undo,
                                      color: undoEnabled
                                          ? Color(0xFF004381)
                                          : Color(0x66001937),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Undo Last Entry',
                                      style: TextStyle(
                                          color: undoEnabled
                                              ? Color(0xFF004381)
                                              : Color(0x66001937),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          PrimaryButton(
                            onPressed: (context) async {
                              int returnedScore = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BasketballOpponentsScorePage()));
                              increaseOpponentScore(
                                  returnedScore, currentGameId);
                            },
                            bgColor: Color(0xFF004381),
                            child: Text(
                              'Opponent Point',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: SecondaryButton(
                                  borderColor: mainBGColor,
                                  onPressed: (context) {
                                    if (isOnBreak) {
                                      setState(() {
                                        quarterNumber++;
                                        isOnBreak = false;
                                      });
                                      DateTime nowDate = DateTime.now();
                                      DataService()
                                          .updateCurrentBasketballGame({
                                        '${quarterNumber}QuarterStart': nowDate,
                                        'currentQuarter': quarterNumber
                                      }, currentGameId);
                                    } else {
                                      setState(() {
                                        isOnBreak = true;
                                      });
                                      DateTime nowDate = DateTime.now();
                                      DataService()
                                          .updateCurrentBasketballGame({
                                        '${quarterNumber}QuarterEnd': nowDate
                                      }, currentGameId);
                                    }
                                  },
                                  child: Text(
                                    isOnBreak ? 'Start QTR' : 'End QTR',
                                    style: TextStyle(
                                        color: mainBGColor,
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
                                  onPressed: (context) async {
                                    await endGame();
                                    bool shouldUndo = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EndGamePage(
                                            firstTeamScore: firstTeamScore,
                                            secondTeamScore: secondTeamScore,
                                            gamedata: gameData,
                                            userData: userData,
                                            isBasketball: true,
                                            gameId: currentGameId,
                                          ),
                                          // fullscreenDialog: true
                                        ));
                                    if (shouldUndo) {
                                      undo();
                                    }
                                  },
                                  borderColor: dangerColor,
                                  child: Text(
                                    'End Game',
                                    style: TextStyle(
                                        color: dangerColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
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
