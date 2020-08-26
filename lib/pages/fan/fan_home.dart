import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/common/helper.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/home_cell.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/basketball/stats/components/stats_history_cell.dart';
import 'package:estats/pages/coach/basketball_home.dart';
import 'package:estats/pages/coach/football_home.dart';
import 'package:estats/pages/coach/profile/profile_page.dart';
import 'package:estats/pages/fan/basketball_stats_page_live.dart';
import 'package:estats/pages/fan/components/live_game_cell.dart';
import 'package:estats/pages/fan/fan_stats_history_page.dart';
import 'package:estats/pages/fan/fan_stats_history_search.dart';
import 'package:estats/pages/fan/stats_page_live.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class FanHomePage extends StatefulWidget {
  @override
  _FanHomePageState createState() => _FanHomePageState();
}

class _FanHomePageState extends State<FanHomePage> {
  File currentSelectedImage;
  int currentSelectedTab = 0;
  bool isLoading = false;
  List<Map<String, dynamic>> currentGamesFan = List<Map<String, dynamic>>();
  DateFormat df = DateFormat('MMMM d, y');
  List<DropdownMenuItem<dynamic>> schoolItems =
      List<DropdownMenuItem<dynamic>>();
  String currentSelectedSchool = '';
  List<String> schoolItemsString = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSchools();
    getCurrentGameFan();
    Timer.periodic(Duration(seconds: 10), (timer) {
      getCurrentGameFanWithoutLoading();
    });
  }

  getSchools() async {
    List<String> schoolNames = await DataService().getSchools();
    for (int j = 0; j < schoolNames.length; j++) {
      schoolItems.add(DropdownMenuItem(
        child: Text('${schoolNames[j]}'),
        value: schoolNames[j],
      ));
      setState(() {
        schoolItemsString.add(schoolNames[j]);
      });
    }
  }

  getCurrentGameFan() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> returned = await DataService().getLiveGames();
    setState(() {
      isLoading = false;
    });
    if (returned != null) {
      setState(() {
        currentGamesFan = returned;
      });
    }
  }

  getCurrentGameFanWithoutLoading() async {
    // setState(() {
    //   isLoading = true;
    // });
    List<Map<String, dynamic>> returned = await DataService().getLiveGames();
    // setState(() {
    //   isLoading = false;
    // });
    if (returned != null) {
      setState(() {
        currentGamesFan = returned;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainBGColor,
      body: !isLoading
          ? ListView(
              children: <Widget>[
                Container(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          title: Container(
                            height: width * 0.085,
                            child: Image.asset(
                              'assets/main_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          actions: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ProfilePage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                    'assets/profile_icon_white.png',
                                  ),
                                  fit: BoxFit.contain,
                                )),
                                height: 38,
                                width: 38,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              HomeCell(
                                text: 'View Game / Stats',
                                imageName: 'pic_football_view_game_stats.png',
                                function: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FanStatsHistoryPage()));
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              HomeCell(
                                text: 'School Search',
                                imageName: 'thumbs_up.png',
                                function: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             ViewRosterPage()));
                                  print('Show now');
                                  // SearchableDropdown.single(
                                  //   items: schoolItems,
                                  //   value: currentSelectedSchool,
                                  //   hint: "Select School",
                                  //   searchHint: "Select School",
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       currentSelectedSchool = value;
                                  //     });
                                  //   },
                                  //   isExpanded: true,
                                  // );
                                  showSearch(
                                      context: context,
                                      delegate: SearchPage<String>(
                                        // barTheme: ThemeData.from(
                                        //     colorScheme: ColorScheme.fromSwatch(
                                        //         backgroundColor: mainBGColor,
                                        //         accentColor: mainBGColor,
                                        //         primarySwatch: mainBGColor)),
                                        items: schoolItemsString,
                                        searchLabel: 'Search School',
                                        suggestion: Center(
                                          child: Text(
                                              'Start typing to find school'),
                                        ),
                                        failure: Center(
                                          child: Text('No school found :('),
                                        ),
                                        filter: (school) => [school],
                                        builder: (school) => ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        FanStatsHistorySearchPage(
                                                          schoolName: school,
                                                        )));
                                          },
                                          title: Text(school),
                                          subtitle: Text(''),
                                          trailing: Text('>'),
                                        ),
                                      ));
                                },
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Live Now',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: List.generate(currentGamesFan.length,
                                    (index) {
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
                                                                      index]
                                                                  ['team_name'],
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
                                                                      index]
                                                                  ['team_name'],
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
                                        secondTeamScore: currentGamesFan[index]
                                            ['second_team_score'],
                                      ),
                                      // SizedBox(
                                      //   height: 20,
                                      // )
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
            ),
    );
  }
}
