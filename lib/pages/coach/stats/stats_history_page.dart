import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/pages/coach/stats/components/stats_history_cell.dart';
import 'package:estats/pages/coach/stats/stats_page.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsHistoryPage extends StatefulWidget {
  @override
  _StatsHistoryPageState createState() => _StatsHistoryPageState();
}

class _StatsHistoryPageState extends State<StatsHistoryPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  DateFormat df = DateFormat('MMMM d, y');
  List<Map<String, dynamic>> games = List<Map<String, dynamic>>();
  Map<String, dynamic> userData = Map<String, dynamic>();

  Future getUserInfo() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> newUserData = await DataService().getCurrentUserData();
    //create new game
    List<Map<String, dynamic>> newGames = await DataService().getAllGames();
    setState(() {
      userData = newUserData;
      isLoading = false;
      games = newGames;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
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
                          'Stats History',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                        width: width,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(games.length, (index) {
                              Timestamp newTimeStamp =
                                  games[index]['startTime'];

                              return StatsHistoryCell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              StatsPage(
                                                date: df.format(
                                                    newTimeStamp.toDate()),
                                                gameId: games[index]
                                                    ['documentId'],
                                                firstTeamImage: userData
                                                    ['imageUrl'],
                                                firstTeamName:
                                                    userData['teamName'],
                                                secondTeamScore: games[index]
                                                    ['opponentPoint'],
                                                firstTeamScore: games[index]
                                                    ['teamPoint'],
                                                secondTeamName: games[index]
                                                    ['opponentName'],
                                              )));
                                },
                                date: df.format(newTimeStamp.toDate()),
                                firstTeamImage: userData['imageUrl'],
                                secondTeamName: games[index]['opponentName'],
                                firstTeamName: userData['teamName'],
                                secondTeamScore: games[index]['opponentPoint'],
                                firstTeamScore: games[index]['teamPoint'],
                              );
                            })),
                      ),
                    ),
                  ],
                )
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
