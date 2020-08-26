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

class BasketballPlayerStatsPage extends StatefulWidget {
  final String playerId;
  BasketballPlayerStatsPage({this.playerId});
  @override
  _BasketballPlayerStatsPageState createState() =>
      _BasketballPlayerStatsPageState();
}

class _BasketballPlayerStatsPageState extends State<BasketballPlayerStatsPage> {
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

  int sectionCount = 1;
  int sectionCount1 = 1;
  // Get row count.
  int _rowCountAtSection(int section) {
    if (section == 0) {
      return 17;
    }
    return 0;
  }

  int _rowCountAtSection1(int section) {
    if (section == 0) {
      return 6;
    }
    return 0;
  }

  Widget _sectionHeaderBuilder(BuildContext context, int section) {
    return Container();
  }

  Widget _sectionHeaderBuilder1(BuildContext context, int section) {
    return Container();
  }

  Widget _cellBuilder(BuildContext context, int section, int row) {
    return InkWell(
        onTap: () async {},
        child: Container(
            padding: EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: row % 2 == 0 ? Colors.white : Color(0xFFF8F8F8),
                border: Border(
                    bottom: BorderSide(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ))),
            height: 100.0,
            child: row == 0
                ?
                //0
                TeamStatCell(
                    title: 'Games Played',
                    subtitle: '${playerStats['games_played']}',
                    flipped: false,
                  )
                : row == 1
                    ? TeamStatCell(
                        title: 'Points',
                        subtitle: '${playerStats['points']}',
                        flipped: true,
                      )
                    : row == 2
                        ? TeamStatCell(
                            title: 'Field Goals Made',
                            subtitle: '${playerStats['field_goals_made']}',
                            flipped: true,
                          )
                        : row == 3
                            ? TeamStatCell(
                                title: 'Field Goals Attempted',
                                subtitle:
                                    '${playerStats['field_goals_attempted']}',
                                flipped: false,
                              )
                            : row == 4
                                ? TeamStatCell(
                                    title: 'Field Goals Percentage',
                                    subtitle:
                                        '${(playerStats['field_goals_percentage'] * 100).toStringAsFixed(1)}%',
                                    flipped: true,
                                  )
                                : row == 5
                                    ? TeamStatCell(
                                        title: 'Three Pointers Made',
                                        subtitle:
                                            '${playerStats['three_pointers_made']}',
                                        flipped: false,
                                      )
                                    : row == 6
                                        ? TeamStatCell(
                                            title: 'Three Pointers Attempted',
                                            subtitle:
                                                '${playerStats['three_pointers_attempted']}',
                                            flipped: true,
                                          )
                                        : row == 7
                                            ? TeamStatCell(
                                                title:
                                                    'Three Pointers Percentage',
                                                subtitle:
                                                    '${(playerStats['three_pointers_percentage'] * 100).toStringAsFixed(1)}%',
                                                flipped: false,
                                              )
                                            : row == 8
                                                ? TeamStatCell(
                                                    title: 'Free Throws Made',
                                                    subtitle:
                                                        '${playerStats['free_throws_made']}',
                                                    flipped: true,
                                                  )
                                                : row == 9
                                                    ? TeamStatCell(
                                                        title:
                                                            'Free Throws Attempted',
                                                        subtitle:
                                                            '${playerStats['free_throws_attempted']}',
                                                        flipped: false,
                                                      )
                                                    : row == 10
                                                        ? TeamStatCell(
                                                            title:
                                                                'Free Throws Percentage',
                                                            subtitle:
                                                                '${(playerStats['free_throws_percentage'] * 100).toStringAsFixed(1)}%',
                                                            flipped: true,
                                                          )
                                                        : row == 11
                                                            ? TeamStatCell(
                                                                title:
                                                                    'Rebounds',
                                                                subtitle:
                                                                    '${playerStats['rebounds']}',
                                                                flipped: false,
                                                              )
                                                            : row == 12
                                                                ? TeamStatCell(
                                                                    title:
                                                                        'Assists',
                                                                    subtitle:
                                                                        '${playerStats['assists']}',
                                                                    flipped:
                                                                        true,
                                                                  )
                                                                : row == 13
                                                                    ? TeamStatCell(
                                                                        title:
                                                                            'Turnovers',
                                                                        subtitle:
                                                                            '${playerStats['turnovers']}',
                                                                        flipped:
                                                                            false,
                                                                      )
                                                                    : row == 14
                                                                        ? TeamStatCell(
                                                                            title:
                                                                                'Steals',
                                                                            subtitle:
                                                                                '${playerStats['steals']}',
                                                                            flipped:
                                                                                true,
                                                                          )
                                                                        : row ==
                                                                                15
                                                                            ? TeamStatCell(
                                                                                title: 'Blocks',
                                                                                subtitle: '${playerStats['blocks']}',
                                                                                flipped: false,
                                                                              )
                                                                            : TeamStatCell(
                                                                                title: 'Fouls',
                                                                                subtitle: '${playerStats['fouls']}',
                                                                                flipped: true,
                                                                              )));
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
                ?
                //0
                TeamInfoCell(
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
    return 0;
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

  // Widget _generateFirstColumnRow(BuildContext context, int index) {
  //   return Container(
  //     child: Text(
  //       playerStats['players'][index]['fullName'],
  //       style: TextStyle(
  //           color: Color(0xFF001937),
  //           fontSize: 14,
  //           fontWeight: FontWeight.w600),
  //     ),
  //     width: 100,
  //     height: 52,
  //     padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }

  // Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         child: Text(
  //           '#${playerStats['players'][index]['number']}',
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           '${playerStats['players'][index]['points']}',
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           '${playerStats['players'][index]['field_goals_made']}',
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           '${playerStats['players'][index]['field_goals_attempted']}',
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           double.parse(
  //                   '${(playerStats['players'][index]['field_goals_percentage'] * 100)}')
  //               .toStringAsFixed(1),
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           '${playerStats['players'][index]['three_pointers_made']}',
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           '${playerStats['players'][index]['three_pointers_attempted']}',
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           double.parse(
  //                   '${(playerStats['players'][index]['three_pointers_percentage'] * 100)}')
  //               .toStringAsFixed(1),
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           '${playerStats['players'][index]['free_throws_made']}',
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           '${playerStats['players'][index]['free_throws_attempted']}',
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //       Container(
  //         child: Text(
  //           double.parse(
  //                   '${(playerStats['players'][index]['free_throws_percentage'] * 100)}')
  //               .toStringAsFixed(1),
  //           style: TextStyle(
  //               color: Color(0xFF001937),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //       ),
  //     ],
  //   );
  // }

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
        await DataService().getBasketballPlayerStats(widget.playerId);
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
                      currentSelectedTab == 1
                          ? Expanded(
                              child: Container(
                                // decoration: BoxDecoration(color: mainBGColor),
                                // height: height * 0.7,
                                child: FlutterTableView(
                                  sectionCount: sectionCount1,
                                  rowCountAtSection: _rowCountAtSection1,
                                  sectionHeaderBuilder: _sectionHeaderBuilder1,
                                  cellBuilder: _cellBuilder1,
                                  sectionHeaderHeight: _sectionHeaderHeight1,
                                  cellHeight: _cellHeight1,
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                // decoration: BoxDecoration(color: mainBGColor),
                                // height: height * 0.7,
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
