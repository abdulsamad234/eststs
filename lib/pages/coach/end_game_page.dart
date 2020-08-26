import 'dart:io';

import 'package:csv/csv.dart';
import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class EndGamePage extends StatefulWidget {
  final int firstTeamScore;
  final int secondTeamScore;
  final Map<String, dynamic> userData;
  final Map<String, dynamic> gamedata;
  final String gameId;
  final bool isBasketball;
  EndGamePage(
      {this.firstTeamScore,
      this.secondTeamScore,
      this.userData,
      this.gamedata,
      this.isBasketball = false,
      this.gameId});
  @override
  _EndGamePageState createState() => _EndGamePageState();
}

class _EndGamePageState extends State<EndGamePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic> gameStats = Map<String, dynamic>();
  String filePath;

  getStats() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> returnedGameStats = widget.isBasketball
        ? await DataService().getBasketballGameStat(widget.gameId)
        : await DataService().getGameStat(widget.gameId);
    print('Returned game Stats: $returnedGameStats');
    setState(() {
      isLoading = false;
      gameStats = returnedGameStats;
    });
  }

  getCsv() async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    if (widget.isBasketball) {
      rows.add([
        "Player Name",
        "Player Number",
        "Points",
        "Field Goals Made",
        "Field Goals Attempted",
        "Field Goals Percentage",
        "Three Pointers Made",
        "Three Pointers Attempted",
        "Three Pointers Percentage",
        "Free Throws Made",
        "Free Throws Attempted",
        "Free Throws Percentage",
        "Rebounds (OR/TR)",
        "Assists",
        "Turnovers",
        "Steals",
        "Blocks",
        "Fouls"
      ]);
    } else {
      rows.add([
        "Player Name",
        "Player Number",
        "Completions",
        "Passes",
        "Pass Percentage",
        "Pass Yards",
        "Pass Touchdowns",
        "Pass Intercepted",
        "Carries",
        "Yards",
        "Average Yards",
        "Touchdowns",
        "Catches",
        "Yards",
        "Average Yards",
        "Touchdowns",
        "Kick Returns",
        "Yards",
        "Touchdowns",
        "Punt Returns",
        "Yards",
        "Touchdowns",
        "FG",
        "XP",
        "Tackles",
        "Sacks",
        "Interceptions",
        "Forced Fumbles",
        "Defensive Touchdowns"
      ]);
    }

    if (gameStats['players'] != null) {
      for (int index = 0; index < gameStats['players'].length; index++) {
        List<dynamic> row = List<dynamic>();
        if (widget.isBasketball) {
          row.add('${gameStats['players'][index]['fullName']}');
          row.add('${gameStats['players'][index]['number']}');
          row.add('${gameStats['players'][index]['points']}');
          row.add('${gameStats['players'][index]['field_goals_made']}');
          row.add('${gameStats['players'][index]['field_goals_attempted']}');
          row.add(double.parse(
                  '${(gameStats['players'][index]['field_goals_percentage'] * 100)}')
              .toStringAsFixed(1));
          row.add('${gameStats['players'][index]['three_pointers_made']}');
          row.add('${gameStats['players'][index]['three_pointers_attempted']}');
          row.add(double.parse(
                  '${(gameStats['players'][index]['three_pointers_percentage'] * 100)}')
              .toStringAsFixed(1));
          row.add('${gameStats['players'][index]['free_throws_made']}');
          row.add('${gameStats['players'][index]['free_throws_attempted']}');
          row.add(double.parse(
                  '${(gameStats['players'][index]['free_throws_percentage'] * 100)}')
              .toStringAsFixed(1));
          row.add('${gameStats['players'][index]['offensive_rebounds']}/${gameStats['players'][index]['rebounds']}');
          row.add('${gameStats['players'][index]['assists']}');
          row.add('${gameStats['players'][index]['turnovers']}');
          row.add('${gameStats['players'][index]['steals']}');
          row.add('${gameStats['players'][index]['blocks']}');
          row.add('${gameStats['players'][index]['fouls']}');
        } else {
          row.add('${gameStats['players'][index]['fullName']}');
          row.add('${gameStats['players'][index]['number']}');
          row.add('${gameStats['players'][index]['comp']}');
          row.add('${gameStats['players'][index]['pass']}');
          row.add('${(gameStats['players'][index]['comp'] / gameStats['players'][index]['pass'] * 100).toStringAsFixed(1)}%');
          row.add('${gameStats['players'][index]['pass_yards']}');
          row.add('${gameStats['players'][index]['pass_touchdown']}');
          row.add('${gameStats['players'][index]['intercepted']}');
          row.add('${gameStats['players'][index]['carries']}');
          row.add('${gameStats['players'][index]['carry_yards']}');
          row.add('${gameStats['players'][index]['carry_yards'] / gameStats['players'][index]['carries']}');
          row.add('${gameStats['players'][index]['carry_touchdown']}');
          row.add('${gameStats['players'][index]['received']}');
          row.add('${gameStats['players'][index]['received_yards']}');
          row.add('${gameStats['players'][index]['received_yards'] / gameStats['players'][index]['received']}');
          row.add('${gameStats['players'][index]['received_touchdown']}');
          row.add('${gameStats['players'][index]['kr']}');
          row.add('${gameStats['players'][index]['kr_yards']}');
          row.add('${gameStats['players'][index]['kr_touchdown']}');
          row.add('${gameStats['players'][index]['pr']}');
          row.add('${gameStats['players'][index]['pr_yards']}');
          row.add('${gameStats['players'][index]['pr_touchdown']}');
          row.add('${gameStats['players'][index]['fg']}/${gameStats['players'][index]['fg_attempted']}');
          row.add('${gameStats['players'][index]['xp']}/${gameStats['players'][index]['xp_attempted']}');
          row.add('${gameStats['players'][index]['tackle']}');
          row.add('${gameStats['players'][index]['sack']}');
          row.add('${gameStats['players'][index]['interception']}');
          row.add('${gameStats['players'][index]['forced_fumble']}');
          row.add('${gameStats['players'][index]['defensive_touchdown']}');
          
          
          
          
        }
        rows.add(row);
      }

      File f = await _localFile;

      String csv = const ListToCsvConverter().convert(rows);
      await f.writeAsString(csv);
      await Share.file('Estats', 'stats.csv', f.readAsBytesSync(), 'file/csv',);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/data.csv';
    return File('$path/data.csv').create();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainBGColor,
      body: Stack(
        children: <Widget>[
          isLoading
              ? Container()
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        // mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            height: height * 0.213,
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: Container(
                              width: width,
                              // child: Image.asset(
                              //   'assets/main_logo.png',
                              //   fit: BoxFit.contain,
                              // ),
                            ),
                          ),
                          Container(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              width: width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Game is Finished',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              height: 90,
                                              width: 90,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        widget.isBasketball
                                                            ? '${widget.userData.containsKey('basketballPicUrl') ? widget.userData['basketballPicUrl'] : ''}'
                                                            : '${widget.userData.containsKey('imageUrl') ? widget.userData['imageUrl'] : ''}',
                                                      ),
                                                      fit: BoxFit.contain)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${widget.userData.containsKey('teamName') ? widget.userData['teamName'] : 'Team 1'}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 35,
                                            ),
                                            Text(
                                              '${widget.firstTeamScore} : ${widget.secondTeamScore}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                        'assets/generic_icon.png',
                                                      ),
                                                      fit: BoxFit.contain)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${widget.gamedata.containsKey('opponentName') ? widget.gamedata['opponentName'] : 'Team 2'}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.undo,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Undo End Game',
                                        style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            PrimaryButton(
                              onPressed: (context) async {
                                setState(() {
                                  isLoading = true;
                                });
                                await getCsv();
                                setState(() {
                                  isLoading = false;
                                });
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) => SignUpPage(
                                //               isCoach: true,
                                //             )));
                              },
                              child: Text(
                                'Share Stats',
                                style: TextStyle(
                                    color: mainBGColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            SecondaryButton(
                              onPressed: (context) {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) =>
                                //             CoachHomePage()));
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CoachHomePage()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                'Back to Home',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                            ),
                          ],
                        ),
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
