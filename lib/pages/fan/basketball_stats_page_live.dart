import 'dart:async';

import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/basketball/stats/basketball_player_stats.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/end_game_page.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/opponents_score_page.dart';
import 'package:estats/pages/coach/stats/components/team_stat_cell.dart';
import 'package:estats/pages/fan/basketball_player_stats_fan.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tableview/flutter_tableview.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class BasketballStatsPageLive extends StatefulWidget {
  final String date;
  final String gameId;
  final String firstTeamImage;
  final String firstTeamName;
  final String secondTeamName;
  final String secondTeamImage;
  final int secondTeamScore;
  final int firstTeamScore;
  BasketballStatsPageLive(
      {this.date = 'December 22, 2019',
      this.gameId,
      this.firstTeamImage,
      this.firstTeamName,
      this.secondTeamImage,
      this.secondTeamName,
      this.secondTeamScore,
      this.firstTeamScore});
  @override
  _BasketballStatsPageLiveState createState() =>
      _BasketballStatsPageLiveState();
}

class _BasketballStatsPageLiveState extends State<BasketballStatsPageLive> {
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
      return 16;
    }
    return 0;
  }

  Widget _sectionHeaderBuilder(BuildContext context, int section) {
    return Container();
  }

  Widget _cellBuilder(BuildContext context, int section, int row) {
    return InkWell(
        onTap: () async {},
        child: Container(
            padding: EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: row % 2 == 1 ? Colors.white : Color(0xFFF8F8F8),
                border: Border(
                    bottom: BorderSide(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ))),
            height: 100.0,
            child: row == 0
                ?
                //0
                TeamStatCell(
                    title: 'Points',
                    subtitle: '${gameStats['points']}',
                    flipped: false,
                  )
                : row == 1
                    ? TeamStatCell(
                        title: 'Field Goals Made',
                        subtitle: '${gameStats['field_goals_made']}',
                        flipped: true,
                      )
                    : row == 2
                        ? TeamStatCell(
                            title: 'Field Goals Attempted',
                            subtitle: '${gameStats['field_goals_attempted']}',
                            flipped: false,
                          )
                        : row == 3
                            ? TeamStatCell(
                                title: 'Field Goals Percentage',
                                subtitle:
                                    '${(gameStats['field_goals_percentage'] * 100).toStringAsFixed(1)}%',
                                flipped: true,
                              )
                            : row == 4
                                ? TeamStatCell(
                                    title: 'Three Pointers Made',
                                    subtitle:
                                        '${gameStats['three_pointers_made']}',
                                    flipped: false,
                                  )
                                : row == 5
                                    ? TeamStatCell(
                                        title: 'Three Pointers Attempted',
                                        subtitle:
                                            '${gameStats['three_pointers_attempted']}',
                                        flipped: true,
                                      )
                                    : row == 6
                                        ? TeamStatCell(
                                            title: 'Three Pointers Percentage',
                                            subtitle:
                                                '${(gameStats['three_pointers_percentage'] * 100).toStringAsFixed(1)}%',
                                            flipped: false,
                                          )
                                        : row == 7
                                            ? TeamStatCell(
                                                title: 'Free Throws Made',
                                                subtitle:
                                                    '${gameStats['free_throws_made']}',
                                                flipped: true,
                                              )
                                            : row == 8
                                                ? TeamStatCell(
                                                    title:
                                                        'Free Throws Attempted',
                                                    subtitle:
                                                        '${gameStats['free_throws_attempted']}',
                                                    flipped: false,
                                                  )
                                                : row == 9
                                                    ? TeamStatCell(
                                                        title:
                                                            'Free Throws Percentage',
                                                        subtitle:
                                                            '${(gameStats['free_throws_percentage'] * 100).toStringAsFixed(1)}%',
                                                        flipped: true,
                                                      )
                                                    : row == 10
                                                        ? TeamStatCell(
                                                            title:
                                                                'Rebounds OR/TR',
                                                            subtitle:
                                                                '${gameStats['offensive_rebounds']}/${gameStats['rebounds']}',
                                                            flipped: false,
                                                          )
                                                        : row == 11
                                                            ? TeamStatCell(
                                                                title:
                                                                    'Assists',
                                                                subtitle:
                                                                    '${gameStats['assists']}',
                                                                flipped: true,
                                                              )
                                                            : row == 12
                                                                ? TeamStatCell(
                                                                    title:
                                                                        'Turnovers',
                                                                    subtitle:
                                                                        '${gameStats['turnovers']}',
                                                                    flipped:
                                                                        false,
                                                                  )
                                                                : row == 13
                                                                    ? TeamStatCell(
                                                                        title:
                                                                            'Steals',
                                                                        subtitle:
                                                                            '${gameStats['steals']}',
                                                                        flipped:
                                                                            true,
                                                                      )
                                                                    : row == 14
                                                                        ? TeamStatCell(
                                                                            title:
                                                                                'Blocks',
                                                                            subtitle:
                                                                                '${gameStats['blocks']}',
                                                                            flipped:
                                                                                false,
                                                                          )
                                                                        : TeamStatCell(
                                                                            title:
                                                                                'Fouls',
                                                                            subtitle:
                                                                                '${gameStats['fouls']}',
                                                                            flipped:
                                                                                true,
                                                                          )));
  }

  double _sectionHeaderHeight(BuildContext context, int section) {
    return 0;
  }

  // Each cell item widget height.
  double _cellHeight(BuildContext context, int section, int row) {
    return 50.0;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF001937))),
      width: width,
      height: 40,
      padding: EdgeInsets.fromLTRB(width == 200 ? 15 : 5, 0, 0, 0),
      alignment: width == 200 ? Alignment.centerLeft : Alignment.center,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('PLAYER', 200),
      _getTitleItemWidget('No.', 50),
      _getTitleItemWidget('PTS', 50),
      _getTitleItemWidget('FGM', 50),
      _getTitleItemWidget('FGA', 50),
      _getTitleItemWidget('FG%', 50),
      _getTitleItemWidget('3PM', 50),
      _getTitleItemWidget('3PA', 50),
      _getTitleItemWidget('3P%', 50),
      _getTitleItemWidget('FTM', 50),
      _getTitleItemWidget('FTA', 50),
      _getTitleItemWidget('FT%', 50),
      _getTitleItemWidget('REBOUNDS (OR/TR)', 100),
      _getTitleItemWidget('ASSISTS', 100),
      _getTitleItemWidget('TURNOVERS', 100),
      _getTitleItemWidget('STEALS', 80),
      _getTitleItemWidget('BLOCKS', 80),
      _getTitleItemWidget('FOULS', 80),
    ];
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        print('Players: ${gameStats['players']}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BasketballPlayerStatsFanPage(
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
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            '#${gameStats['players'][index]['number']}',
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
            '${gameStats['players'][index]['points']}',
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
            '${gameStats['players'][index]['field_goals_made']}',
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
            '${gameStats['players'][index]['field_goals_attempted']}',
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
            double.parse(
                    '${(gameStats['players'][index]['field_goals_percentage'] * 100)}')
                .toStringAsFixed(1),
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
            '${gameStats['players'][index]['three_pointers_made']}',
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
            '${gameStats['players'][index]['three_pointers_attempted']}',
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
            double.parse(
                    '${(gameStats['players'][index]['three_pointers_percentage'] * 100)}')
                .toStringAsFixed(1),
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
            '${gameStats['players'][index]['free_throws_made']}',
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
            '${gameStats['players'][index]['free_throws_attempted']}',
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
            double.parse(
                    '${(gameStats['players'][index]['free_throws_percentage'] * 100)}')
                .toStringAsFixed(1),
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
            '${gameStats['players'][index]['offensive_rebounds']}/${gameStats['players'][index]['rebounds']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${gameStats['players'][index]['assists']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${gameStats['players'][index]['turnovers']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${gameStats['players'][index]['steals']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${gameStats['players'][index]['blocks']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            '${gameStats['players'][index]['fouls']}',
            style: TextStyle(
                color: Color(0xFF001937),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          width: 80,
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
    getStats();
    Timer.periodic(Duration(seconds: 10), (timer) {
      getStatsWithoutLoading();
    });
  }

  getStats() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> returnedGameStats =
        await DataService().getBasketballGameStatFan(widget.gameId);
    print('Returned game Stats: $returnedGameStats');
    setState(() {
      isLoading = false;
      gameStats = returnedGameStats;
    });
  }

  getStatsWithoutLoading() async {
    Map<String, dynamic> returnedGameStats =
        await DataService().getBasketballGameStatFan(widget.gameId);
    print('Returned game Stats: $returnedGameStats');
    setState(() {
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
                            'Live Now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      // currentSelectedTab == 0
                      //     ? Container(
                      //         decoration: BoxDecoration(color: mainBGColor),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: <Widget>[
                      //             Text(
                      //               'Offense',
                      //               style: TextStyle(
                      //                   color: Colors.white, fontSize: 18),
                      //             ),
                      //             Switch(
                      //               value: isDefence,
                      //               onChanged: (newVal) {
                      //                 setState(() {
                      //                   isDefence = newVal;
                      //                 });
                      //               },
                      //               activeColor: Colors.white,
                      //               activeTrackColor: darkBGColor,
                      //               inactiveThumbColor: Colors.white,
                      //               inactiveTrackColor: darkBGColor,
                      //             ),
                      //             Text(
                      //               'Defense',
                      //               style: TextStyle(
                      //                   color: Colors.white, fontSize: 18),
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     : Container(),
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(color: mainBGColor),
                              child: Text(
                                (gameStats['game']['currentQuarter'] % 10 ==
                                            1 &&
                                        gameStats['game']['currentQuarter'] %
                                                100 !=
                                            11
                                    ? '${gameStats['game']['currentQuarter']}st QTR'
                                    : gameStats['game']['currentQuarter'] %
                                                    10 ==
                                                2 &&
                                            gameStats['game']
                                                        ['currentQuarter'] %
                                                    100 !=
                                                12
                                        ? '${gameStats['game']['currentQuarter']}nd QTR'
                                        : gameStats['game']['currentQuarter'] %
                                                        10 ==
                                                    3 &&
                                                gameStats['game']
                                                            ['currentQuarter'] %
                                                        100 !=
                                                    13
                                            ? '${gameStats['game']['currentQuarter']}rd QTR'
                                            : '${gameStats['game']['currentQuarter']}th QTR'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                  rightHandSideColumnWidth: 1090,
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
                      ),
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
