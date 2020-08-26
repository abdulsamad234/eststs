import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/pages/coach/stats/components/stats_history_cell.dart';
import 'package:estats/pages/coach/stats/stats_page.dart';
import 'package:estats/pages/fan/basketball_stats_fan.dart';
import 'package:estats/pages/fan/basketball_stats_page_live.dart';
import 'package:estats/pages/fan/stats_page_fan.dart';
import 'package:estats/pages/fan/stats_page_live.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/live_game_cell.dart';

class FanStatsHistoryPage extends StatefulWidget {
  @override
  _FanStatsHistoryPageState createState() => _FanStatsHistoryPageState();
}

class _FanStatsHistoryPageState extends State<FanStatsHistoryPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  DateFormat df = DateFormat('MMMM d, y');
  List<Map<String, dynamic>> games = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> basketballGames = List<Map<String, dynamic>>();
  Map<String, dynamic> userData = Map<String, dynamic>();
  List<Map<String, dynamic>> currentGamesFan = List<Map<String, dynamic>>();

  int currentSelectedTab = 0;

  getAll() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> returned = await DataService().getLiveGames();
    Map<String, dynamic> newUserData = await DataService().getCurrentUserData();
    //create new game
    List<Map<String, dynamic>> newGames = await DataService().getAllFanGames();
    List<Map<String, dynamic>> newBasketballGames =
        await DataService().getAllFanBasketballGames();
    print('New games: $newGames');
    print('New basketball games: $newBasketballGames');
    setState(() {
      userData = newUserData;
      isLoading = false;
      games = newGames;
      basketballGames = newBasketballGames;
      if (returned != null) {
        currentGamesFan = returned;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainBGColor,
      body: Stack(
        children: <Widget>[
          !isLoading
              ? ListView(
                  // mainAxisSize: MainAxisSize.max,
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
                              color: whiteColor,
                            ),
                          ),
                          title: Text(
                            'Stats',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Container(
                          child: Container(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, bottom: 30, top: 10),
                              width: width,
                              child: Column(children: <Widget>[
                                Text(
                                  'Live Now',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: List.generate(
                                      currentGamesFan.length, (index) {
                                    return Column(
                                      children: <Widget>[
                                        LiveGameCell(
                                          onTap: () {
                                            if (currentGamesFan[index]
                                                ['is_basketball']) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          BasketballStatsPageLive(
                                                            date: df.format(
                                                                DateTime.now()),
                                                            firstTeamImage:
                                                                currentGamesFan[
                                                                        index][
                                                                    'team_image'],
                                                            firstTeamName:
                                                                currentGamesFan[
                                                                        index][
                                                                    'team_name'],
                                                            secondTeamName:
                                                                currentGamesFan[
                                                                        index][
                                                                    'second_team_name'],
                                                            gameId:
                                                                currentGamesFan[
                                                                        index][
                                                                    'documentId'],
                                                          )));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          StatsPageLive(
                                                            date: df.format(
                                                                DateTime.now()),
                                                            firstTeamImage:
                                                                currentGamesFan[
                                                                        index][
                                                                    'team_image'],
                                                            firstTeamName:
                                                                currentGamesFan[
                                                                        index][
                                                                    'team_name'],
                                                            secondTeamName:
                                                                currentGamesFan[
                                                                        index][
                                                                    'second_team_name'],
                                                            gameId:
                                                                currentGamesFan[
                                                                        index][
                                                                    'documentId'],
                                                          )));
                                            }
                                          },
                                          firstTeamImage: currentGamesFan[index]
                                              ['team_image'],
                                          secondTeamImage: '',
                                          secondTeamName: currentGamesFan[index]
                                              ['second_team_name'],
                                          firstTeamName: currentGamesFan[index]
                                              ['team_name'],
                                          firstTeamScore: currentGamesFan[index]
                                              ['team_score'],
                                          secondTeamScore:
                                              currentGamesFan[index]
                                                  ['second_team_score'],
                                        ),
                                        // SizedBox(
                                        //   height: 20,
                                        // )
                                      ],
                                    );
                                  }),
                                ),
                                Text(
                                  'All games',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    currentSelectedTab = 0;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  child: Center(
                                                    child: Text(
                                                      'Football',
                                                      style: TextStyle(
                                                          color:
                                                              currentSelectedTab ==
                                                                      0
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFF001937),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  decoration: this
                                                              .currentSelectedTab ==
                                                          0
                                                      ? BoxDecoration(
                                                          color:
                                                              Color(0xFF001937),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)))
                                                      : BoxDecoration(),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    currentSelectedTab = 1;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  child: Center(
                                                    child: Text(
                                                      'Basketball',
                                                      style: TextStyle(
                                                          color:
                                                              currentSelectedTab ==
                                                                      1
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFF001937),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  decoration: this
                                                              .currentSelectedTab ==
                                                          1
                                                      ? BoxDecoration(
                                                          color:
                                                              Color(0xFF001937),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)))
                                                      : BoxDecoration(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                currentSelectedTab == 0
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: List.generate(games.length,
                                            (index) {
                                          Timestamp newTimeStamp =
                                              games[index]['startTime'];
                                          print('GAme: ${games[index]}');

                                          return StatsHistoryCell(
                                            onTap: () {
                                              print('Name here: ${games[index]['teamName']}');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          StatsPageFan(
                                                            date: df.format(
                                                                newTimeStamp
                                                                    .toDate()),
                                                            gameId: games[index]
                                                                ['documentId'],
                                                            firstTeamImage:
                                                                games[index][
                                                                    'imageUrl'],
                                                            firstTeamName:
                                                                games[index][
                                                                    'teamName'],
                                                            secondTeamScore: games[
                                                                    index][
                                                                'opponentPoint'],
                                                            firstTeamScore:
                                                                games[index][
                                                                    'teamPoint'],
                                                            secondTeamName: games[
                                                                    index][
                                                                'opponentName'],
                                                          )));
                                            },
                                            date: df
                                                .format(newTimeStamp.toDate()),
                                            firstTeamImage: games[index]
                                                ['imageUrl'],
                                            secondTeamName: games[index]
                                                ['opponentName'],
                                            firstTeamName: games[index]
                                                ['teamName'],
                                            secondTeamScore: games[index]
                                                ['opponentPoint'],
                                            firstTeamScore: games[index]
                                                ['teamPoint'],
                                          );
                                        }))
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: List.generate(
                                            basketballGames.length, (index) {
                                          Timestamp newTimeStamp =
                                              basketballGames[index]
                                                  ['startTime'];
                                          print(
                                              'GAme: ${basketballGames[index]}');

                                          return StatsHistoryCell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          BasketballStatsPageFan(
                                                            date: df.format(
                                                                newTimeStamp
                                                                    .toDate()),
                                                            gameId:
                                                                basketballGames[
                                                                        index][
                                                                    'documentId'],
                                                            firstTeamImage:
                                                                basketballGames[
                                                                        index][
                                                                    'basketballPicUrl'],
                                                            firstTeamName:
                                                                basketballGames[
                                                                        index][
                                                                    'teamName'],
                                                            secondTeamScore:
                                                                basketballGames[
                                                                        index][
                                                                    'opponentPoint'],
                                                            firstTeamScore:
                                                                basketballGames[
                                                                        index][
                                                                    'teamPoint'],
                                                            secondTeamName:
                                                                basketballGames[
                                                                        index][
                                                                    'opponentName'],
                                                          )));
                                            },
                                            date: df
                                                .format(newTimeStamp.toDate()),
                                            firstTeamImage:
                                                basketballGames[index]
                                                    ['basketballPicUrl'],
                                            secondTeamName:
                                                basketballGames[index]
                                                    ['opponentName'],
                                            firstTeamName:
                                                basketballGames[index]
                                                    ['teamName'],
                                            secondTeamScore:
                                                basketballGames[index]
                                                    ['opponentPoint'],
                                            firstTeamScore:
                                                basketballGames[index]
                                                    ['teamPoint'],
                                          );
                                        })),
                              ])))
                    ])
              : Container(),
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
