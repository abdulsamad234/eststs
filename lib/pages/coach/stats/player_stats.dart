import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/basketball/stats/components/team_info_cell.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/end_game_page.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/opponents_score_page.dart';
import 'package:estats/pages/coach/stats/components/team_stat_cell.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tableview/flutter_tableview.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class PlayerStatsPage extends StatefulWidget {
  final String playerId;
  PlayerStatsPage({this.playerId});
  @override
  _PlayerStatsPageState createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  int quarterNumber = 1;
  int firstTeamScore = 0;
  int secondTeamScore = 0;
  bool isOnBreak = false;
  int currentSelectedTab = 0;
  bool isDefence = false;
  Map<String, dynamic> playerStats = Map<String, dynamic>();

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

  // Map<String,dynamic> gameStats = Map<String, dynamic>();

  int sectionCount = 6;
  int sectionCount1 = 1;
  // Get row count.
  int _rowCountAtSection(int section) {
    if (section == 0) {
      return 4;
    } else if (section == 1) {
      return 3;
    } else if (section == 2) {
      return 3;
    } else if (section == 3) {
      return 5;
    } else if (section == 4) {
      return 6;
    } else {
      return 2;
    }
  }

  int _rowCountAtSection1(int section) {
    if (section == 0) {
      return 6;
    }
    return 0;
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
                      : section == 3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('DEFENSE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF001937))))
                              ],
                            )
                          : section == 4
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        child: Text('RETURN',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF001937))))
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        child: Text('KICK',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF001937))))
                                  ],
                                )),
    );
  }

  Widget _sectionHeaderBuilder1(BuildContext context, int section) {
    return Container();
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
                          '${playerStats['completed_pass']}/${playerStats['total_pass']}',
                    )
                  : row == 1
                      ? TeamStatCell(
                          title: 'Yards',
                          subtitle: '${playerStats['pass_yards']}',
                        )
                      : row == 2
                          ? TeamStatCell(
                              title: 'Interceptions',
                              subtitle: '${playerStats['intercepted_pass']}',
                            )
                          : TeamStatCell(
                              title: 'Touchdowns',
                              subtitle: '${playerStats['touchdown_pass']}',
                            )
              : section == 1
                  ? row == 0
                      ? TeamStatCell(
                          title: 'Catches',
                          subtitle: '${playerStats['pass_catches']}',
                        )
                      : row == 1
                          ? TeamStatCell(
                              title: 'Yards',
                              subtitle: '${playerStats['catch_yards']}',
                            )
                          : TeamStatCell(
                              subtitle: '${playerStats['catch_touchdowns']}',
                              title: 'Touchdowns',
                            )
                  : section == 2
                      ? row == 0
                          ? TeamStatCell(
                              title: 'Carries',
                              subtitle: '${playerStats['runs']}',
                            )
                          : row == 1
                              ? TeamStatCell(
                                  title: 'Yards',
                                  subtitle: '${playerStats['run_yards']}',
                                )
                              : TeamStatCell(
                                  subtitle: '${playerStats['run_touchdown']}',
                                  title: 'Touchdowns',
                                )
                      : section == 3
                          ? row == 0
                              ? TeamStatCell(
                                  title: 'Tackles',
                                  subtitle: '${playerStats['tackles']}',
                                )
                              : row == 1
                                  ? TeamStatCell(
                                      title: 'Sacks',
                                      subtitle: '${playerStats['sacks']}',
                                    )
                                  : row == 2
                                      ? TeamStatCell(
                                          title: 'Interceptions',
                                          subtitle:
                                              '${playerStats['intercepts']}',
                                        )
                                      : row == 3
                                          ? TeamStatCell(
                                              title: 'Forced Fumbles',
                                              subtitle:
                                                  '${playerStats['fumbles']}',
                                            )
                                          : TeamStatCell(
                                              title: 'Defensive Touchdowns',
                                              subtitle:
                                                  '${playerStats['defensive_touchdown']}',
                                            )
                          : section == 4
                              ? row == 0
                                  ? TeamStatCell(
                                      title: 'Kick Return',
                                      subtitle: '${playerStats['kr']}',
                                    )
                                  : row == 1
                                      ? TeamStatCell(
                                          title: 'Yards',
                                          subtitle:
                                              '${playerStats['kr_yards']}',
                                        )
                                      : row == 2
                                          ? TeamStatCell(
                                              title: 'Touchdowns',
                                              subtitle:
                                                  '${playerStats['kr_touchdown']}',
                                            )
                                          : row == 3
                                              ? TeamStatCell(
                                                  title: 'Punt Return',
                                                  subtitle:
                                                      '${playerStats['pr']}',
                                                )
                                              : row == 4
                                                  ? TeamStatCell(
                                                      title: 'Yards',
                                                      subtitle:
                                                          '${playerStats['pr_yards']}',
                                                    )
                                                  : TeamStatCell(
                                                      title: 'Touchdowns',
                                                      subtitle:
                                                          '${playerStats['pr_touchdown']}',
                                                    )
                              : row == 0
                                  ? TeamStatCell(
                                      title: 'FG',
                                      subtitle: '${playerStats['fg']}/${playerStats['fg_attempted']}',
                                    )
                                  : TeamStatCell(
                                      title: 'XP',
                                      subtitle: '${playerStats['xp']}/${playerStats['xp_attempted']}',
                                    )),
    );
  }

  Widget _cellBuilder1(BuildContext context, int section, int row) {
    return InkWell(
        onTap: () async {},
        child: Container(
            padding: EdgeInsets.only(left: 16.0, top: 25, bottom: 25),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: row % 2 == 0 ? Colors.white : Color(0xFFF8F8F8),
                border: Border(
                    bottom: BorderSide(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ))),
            height: 100.0,
            child: row == 0
                ? TeamInfoCell(
                    title: 'Full Name',
                    subtitle: '${playerStats['player']['fullName']}',
                    flipped: false,
                  )
                : row == 1
                    ? TeamInfoCell(
                        title: 'Number',
                        subtitle: '#${playerStats['player']['number']}',
                        flipped: true,
                      )
                    : row == 2
                        ? TeamInfoCell(
                            title: 'Age',
                            subtitle: '${playerStats['player']['age']}',
                            flipped: true,
                          )
                        : row == 3
                            ? TeamInfoCell(
                                title: 'Position',
                                subtitle:
                                    '${playerStats['player']['position']}',
                                flipped: false,
                              )
                            : row == 4
                                ? TeamInfoCell(
                                    title: 'Height',
                                    subtitle:
                                        '${playerStats['player']['height']} ft',
                                    flipped: true,
                                  )
                                : TeamInfoCell(
                                    title: 'Weight',
                                    subtitle:
                                        '${playerStats['player']['weight']} lbs',
                                    flipped: false,
                                  )));
  }

  double _sectionHeaderHeight(BuildContext context, int section) {
    return 50.0;
  }

  double _sectionHeaderHeight1(BuildContext context, int section) {
    return 0;
  }

  // Each cell item widget height.
  double _cellHeight(BuildContext context, int section, int row) {
    return 50.0;
  }

  double _cellHeight1(BuildContext context, int section, int row) {
    return 100.0;
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
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStats();
  }

  getStats() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> returnedPlayerStats =
        await DataService().getPlayerStats(widget.playerId);
    print('Returned game Stats: $returnedPlayerStats');
    setState(() {
      isLoading = false;
      playerStats = returnedPlayerStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ScrollController controller = ScrollController();
    return Scaffold(
      backgroundColor: mainBGColor,
      body: Stack(
        children: <Widget>[
          !isLoading
              ? Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    // shrinkWrap: true,
                    // // mainAxisSize: MainAxisSize.max,
                    // padding: EdgeInsets.all(0),
                    // controller: controller,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Color(0xFFBEC7D0)),
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
                              color: Color(0xFF001937),
                            ),
                          ),
                          title: Text(
                            'Player Stats',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF001937),
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
                          decoration: BoxDecoration(color: Color(0xFFBEC7D0)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                            image:
                                                //     // widget.firstTeamImage == null
                                                //     //     ?
                                                //     AssetImage(
                                                //   'assets/packers_logo.png',
                                                // )

                                                NetworkImage(
                                                    playerStats['player']
                                                        ['imageUrl']),
                                            fit: BoxFit.contain)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    // widget.firstTeamName == null
                                    //     ? widget.firstTeamName
                                    //     :
                                    '#${playerStats['player']['number']} ${playerStats['player']['fullName']}',
                                    style: TextStyle(
                                        color: Color(0xFF001937),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Container(
                          decoration: BoxDecoration(color: Color(0xFFBEC7D0)),
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
                                                'Stats',
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
                                                'Info',
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
                        child: currentSelectedTab == 1
                            ? Container(
                                // decoration: BoxDecoration(color: mainBGColor),
                                // height: height * 0.7,
                                child: FlutterTableView(
                                  sectionCount: sectionCount1,
                                  rowCountAtSection: _rowCountAtSection1,
                                  sectionHeaderBuilder: _sectionHeaderBuilder1,
                                  cellBuilder: _cellBuilder1,
                                  sectionHeaderHeight: _sectionHeaderHeight1,
                                  cellHeight: _cellHeight1,
                                  controller: controller,
                                ),
                              )
                            : Container(
                                // decoration: BoxDecoration(color: mainBGColor),
                                // height: height * 0.7,
                                child: FlutterTableView(
                                  sectionCount: sectionCount,
                                  rowCountAtSection: _rowCountAtSection,
                                  sectionHeaderBuilder: _sectionHeaderBuilder,
                                  cellBuilder: _cellBuilder,
                                  sectionHeaderHeight: _sectionHeaderHeight,
                                  cellHeight: _cellHeight,
                                  controller: controller,
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
