import 'dart:async';

import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/end_game_page.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/opponents_score_page.dart';
import 'package:estats/pages/coach/stats/components/team_stat_cell.dart';
import 'package:estats/pages/coach/stats/player_stats.dart';
import 'package:estats/pages/fan/player_stats_fan.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tableview/flutter_tableview.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class StatsPageFan extends StatefulWidget {
  final String date;
  final String gameId;
  final String firstTeamImage;
  final String firstTeamName;
  final String secondTeamName;
  final String secondTeamImage;
  final int secondTeamScore;
  final int firstTeamScore;
  StatsPageFan(
      {this.date = 'December 22, 2019',
      this.gameId,
      this.firstTeamImage,
      this.firstTeamName,
      this.secondTeamImage,
      this.secondTeamName,
      this.secondTeamScore,
      this.firstTeamScore});
  @override
  _StatsPageFanState createState() => _StatsPageFanState();
}

class _StatsPageFanState extends State<StatsPageFan> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  int quarterNumber = 1;
  int firstTeamScore = 0;
  int secondTeamScore = 0;
  bool isOnBreak = false;
  int currentSelectedTab = 0;
  bool isDefence = false;
  Map<String, dynamic> gameStats = Map<String, dynamic>();

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

  // Map<String,dynamic> gameStats = Map<String, dynamic>();

  int sectionCount = 4;
  // Get row count.
  int _rowCountAtSection(int section) {
    if (section == 0) {
      return 4;
    } else if (section == 1) {
      return 3;
    } else if (section == 2) {
      return 3;
    } else {
      return 4;
    }
  }

  Widget _sectionHeaderBuilder(BuildContext context, int section) {
    return InkWell(
      onTap: () {
        print('click section header. -> section:$section');
      },
      child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16),
          color: Color(0xFFF6F6F6),
          height: 30,
          child: section == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      Container(
                          child: Text('PASSING',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF001937))))
                    ])
              : section == 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: Text('RECEIVING',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF001937))))
                      ],
                    )
                  : section == 2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                child: Text('RUSHING',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF001937))))
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                child: Text('DEFENSE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF001937))))
                          ],
                        )),
    );
  }

  Widget _cellBuilder(BuildContext context, int section, int row) {
    return InkWell(
      onTap: () async {
        if (section == 1) {
          if (row == 0) {
          } else if (row == 1) {}
        }
      },
      child: Container(
          padding: EdgeInsets.only(left: 16.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Color.fromRGBO(240, 240, 240, 1),
          ))),
          height: 100.0,
          child: section == 0
              ? row == 0
                  ?
                  //0
                  TeamStatCell(
                      title: 'Completion',
                      subtitle:
                          '${gameStats['team_completed_pass']}/${gameStats['team_total_pass']}',
                    )
                  : row == 1
                      ? TeamStatCell(
                          title: 'Yards',
                          subtitle: '${gameStats['team_pass_yards']}',
                        )
                      : row == 2
                          ? TeamStatCell(
                              title: 'Interceptions',
                              subtitle: '${gameStats['team_intercepted_pass']}',
                            )
                          : TeamStatCell(
                              title: 'Touchdowns',
                              subtitle: '${gameStats['team_touchdown_pass']}',
                            )
              : section == 1
                  ? row == 0
                      ? TeamStatCell(
                          title: 'Catches',
                          subtitle: '${gameStats['team_pass_catches']}',
                        )
                      : row == 1
                          ? TeamStatCell(
                              title: 'Yards',
                              subtitle: '${gameStats['team_catch_yards']}',
                            )
                          : TeamStatCell(
                              subtitle: '${gameStats['team_catch_touchdowns']}',
                              title: 'Touchdowns',
                            )
                  : section == 2
                      ? row == 0
                          ? TeamStatCell(
                              title: 'Carries',
                              subtitle: '${gameStats['team_runs']}',
                            )
                          : row == 1
                              ? TeamStatCell(
                                  title: 'Yards',
                                  subtitle: '${gameStats['team_run_yards']}',
                                )
                              : TeamStatCell(
                                  subtitle:
                                      '${gameStats['team_run_touchdown']}',
                                  title: 'Touchdowns',
                                )
                      : row == 0
                          ? TeamStatCell(
                              title: 'Tackles',
                              subtitle: '${gameStats['team_tackles']}',
                            )
                          : row == 1
                              ? TeamStatCell(
                                  title: 'Sacks',
                                  subtitle: '${gameStats['team_sacks']}',
                                )
                              : row == 2
                                  ? TeamStatCell(
                                      title: 'Interceptions',
                                      subtitle:
                                          '${gameStats['team_intercepts']}',
                                    )
                                  : TeamStatCell(
                                      title: 'Forced Fumbles',
                                      subtitle: '${gameStats['team_fumbles']}',
                                    )),
    );
  }

  double _sectionHeaderHeight(BuildContext context, int section) {
    return 50.0;
  }

  // Each cell item widget height.
  double _cellHeight(BuildContext context, int section, int row) {
    return 50.0;
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

  List<Widget> _getTitleWidget() {
    return isDefence
        ? [
            _getTitleItemWidget('DEFENSE', 200),
            _getTitleItemWidget('No.', 40),
            _getTitleItemWidget('TKL', 40),
            _getTitleItemWidget('SAC', 40),
            _getTitleItemWidget('INT', 40),
            _getTitleItemWidget('FF', 40),
            _getTitleItemWidget('DTD', 40),
          ]
        : [
            _getTitleItemWidget('OFFENSE', 200),
            _getTitleItemWidget('No.', 40),
            _getTitleItemWidget('COMP', 50),
            _getTitleItemWidget('PASS', 50),
            _getTitleItemWidget('P%', 60),
            _getTitleItemWidget('YARDS', 60),
            _getTitleItemWidget('TD', 40),
            _getTitleItemWidget('INT', 40),
            _getTitleItemWidget('CARRIES', 70),
            _getTitleItemWidget('YARDS', 60),
            _getTitleItemWidget('AVG', 60),
            _getTitleItemWidget('TD', 40),
            _getTitleItemWidget('REC', 40),
            _getTitleItemWidget('YARDS', 60),
            _getTitleItemWidget('AVG', 60),
            _getTitleItemWidget('TD', 40),
            _getTitleItemWidget('KR', 40),
            _getTitleItemWidget('YARDS', 60),
            _getTitleItemWidget('TD', 40),
            _getTitleItemWidget('PR', 40),
            _getTitleItemWidget('YARDS', 60),
            _getTitleItemWidget('TD', 40),
            _getTitleItemWidget('FG', 40),
            _getTitleItemWidget('XP', 40),
          ];
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PlayerStatsFanPage(
                      playerId: gameStats['players'][index]['playerId'],
                    )));
      },
      child: Container(
        child: Text(
          gameStats['players'][index]['fullName'],
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
    return isDefence
        ? Row(
            children: <Widget>[
              Container(
                child: Text(
                  '#${gameStats['players'][index]['number']}',
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
                  '${gameStats['players'][index]['tackle']}',
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
                  '${gameStats['players'][index]['sack']}',
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
                  '${gameStats['players'][index]['interception']}',
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
                  '${gameStats['players'][index]['forced_fumble']}',
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
                  '${gameStats['players'][index]['defensive_touchdown']}',
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
            ],
          )
        : Row(
            children: <Widget>[
              Container(
                child: Text(
                  '#${gameStats['players'][index]['number']}',
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
                  '${gameStats['players'][index]['comp']}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 50,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${gameStats['players'][index]['pass']}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 50,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${(gameStats['players'][index]['comp'] / gameStats['players'][index]['pass'] * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 60,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${gameStats['players'][index]['pass_yards']}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 60,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${gameStats['players'][index]['pass_touchdown']}',
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
                  '${gameStats['players'][index]['intercepted']}',
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
                  '${gameStats['players'][index]['carries']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 70,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${gameStats['players'][index]['carry_yards']}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 60,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${(gameStats['players'][index]['carry_yards'] / gameStats['players'][index]['carries']).toStringAsFixed(1)}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 60,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${gameStats['players'][index]['carry_touchdown']}',
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
                  '${gameStats['players'][index]['received']}',
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
                  '${gameStats['players'][index]['received_yards']}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 60,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${(gameStats['players'][index]['received_yards'] / gameStats['players'][index]['received']).toStringAsFixed(1)}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 60,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${gameStats['players'][index]['received_touchdown']}',
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
                  '${gameStats['players'][index]['kr']}',
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
                  '${gameStats['players'][index]['kr_yards']}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 60,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${gameStats['players'][index]['kr_touchdown']}',
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
                  '${gameStats['players'][index]['pr']}',
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
                  '${gameStats['players'][index]['pr_yards']}',
                  style: TextStyle(
                      color: Color(0xFF001937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                width: 60,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.center,
              ),
              Container(
                child: Text(
                  '${gameStats['players'][index]['pr_touchdown']}',
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
                  '${gameStats['players'][index]['fg']}/${gameStats['players'][index]['fg_attempted']}',
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
                  '${gameStats['players'][index]['xp']}/${gameStats['players'][index]['xp_attempted']}',
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
            ],
          );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Widget one: ${widget.firstTeamName}');
    getStats();
    
  }

  getStats() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> returnedGameStats =
        await DataService().getGameStatFan(widget.gameId);
    print('Returned game Stats: $returnedGameStats');
    setState(() {
      isLoading = false;
      gameStats = returnedGameStats;
    });
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
              ? Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: mainBGColor),
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
                            '${widget.date}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      currentSelectedTab == 0
                          ? Container(
                              decoration: BoxDecoration(color: mainBGColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Offense',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Switch(
                                    value: isDefence,
                                    onChanged: (newVal) {
                                      setState(() {
                                        isDefence = newVal;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: darkBGColor,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: darkBGColor,
                                  ),
                                  Text(
                                    'Defense',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                          decoration: BoxDecoration(color: mainBGColor),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: 90,
                                    width: 90,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        image: DecorationImage(
                                            image: widget.firstTeamImage == null
                                                ? AssetImage(
                                                    'assets/packers_logo.png',
                                                  )
                                                : NetworkImage(
                                                    widget.firstTeamImage),
                                            fit: BoxFit.contain)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.firstTeamName != null
                                        ? widget.firstTeamName
                                        : 'Packers',
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
                                    '${gameStats['game']['teamPoint']} : ${gameStats['game']['opponentPoint']}',
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
                                        borderRadius: BorderRadius.all(
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
                                    '${gameStats['game']['opponentName']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Container(
                          decoration: BoxDecoration(color: mainBGColor),
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 30),
                          child: Row(
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
                                                'Player',
                                                style: TextStyle(
                                                    color:
                                                        currentSelectedTab == 0
                                                            ? Colors.white
                                                            : Color(0xFF001937),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            decoration:
                                                this.currentSelectedTab == 0
                                                    ? BoxDecoration(
                                                        color:
                                                            Color(0xFF001937),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
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
                                                'Team',
                                                style: TextStyle(
                                                    color:
                                                        currentSelectedTab == 1
                                                            ? Colors.white
                                                            : Color(0xFF001937),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            decoration:
                                                this.currentSelectedTab == 1
                                                    ? BoxDecoration(
                                                        color:
                                                            Color(0xFF001937),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
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
                          )),
                      Expanded(
                        child: currentSelectedTab == 0
                            ? Container(
                                child: HorizontalDataTable(
                                  leftHandSideColumnWidth: 200,
                                  rightHandSideColumnWidth:
                                      isDefence ? 240 : 1130,
                                  isFixedHeader: true,
                                  headerWidgets: _getTitleWidget(),
                                  leftSideItemBuilder: _generateFirstColumnRow,
                                  rightSideItemBuilder:
                                      _generateRightHandSideColumnRow,
                                  itemCount: gameStats['players'].length,
                                  rowSeparatorWidget: const Divider(
                                    color: Colors.black12,
                                    height: 2.0,
                                    thickness: 0.0,
                                  ),
                                  leftHandSideColBackgroundColor:
                                      Color(0xFFDDE4EB),
                                  rightHandSideColBackgroundColor:
                                      Color(0xFFFFFFFF),
                                ),
                              )
                            : Container(
                                child: FlutterTableView(
                                  sectionCount: sectionCount,
                                  rowCountAtSection: _rowCountAtSection,
                                  sectionHeaderBuilder: _sectionHeaderBuilder,
                                  cellBuilder: _cellBuilder,
                                  sectionHeaderHeight: _sectionHeaderHeight,
                                  cellHeight: _cellHeight,
                                ),
                              ),
                      )
                    ],
                  ),
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
