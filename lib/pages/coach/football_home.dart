import 'package:estats/components/home_cell.dart';
import 'package:estats/pages/coach/new_game/football_new_game.dart';
import 'package:estats/pages/coach/stats/stats_history_page.dart';
import 'package:estats/pages/coach/view_roster/view_roster_page.dart';
import 'package:flutter/material.dart';

class FootballHome extends StatefulWidget {
  @override
  _FootballHomeState createState() => _FootballHomeState();
}

class _FootballHomeState extends State<FootballHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HomeCell(
          text: 'New Game',
          imageName: 'pic_football_new_game.png',
          function: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => FootballNewGame()));
          },
        ),
        SizedBox(
          height: 20,
        ),
        HomeCell(
          text: 'View Roster',
          imageName: 'pic_football_new_roster.png',
          function: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ViewRosterPage()));
          },
        ),
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
                    builder: (BuildContext context) => StatsHistoryPage()));
          },
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
