import 'package:estats/components/home_cell.dart';
import 'package:estats/pages/coach/basketball/basketball_new_game/basketball_new_game.dart';
import 'package:estats/pages/coach/basketball/stats/basketball_stats_history_page.dart';
import 'package:estats/pages/coach/basketball/view_roster/view_basketball_roster_page.dart';
import 'package:flutter/material.dart';

class BasketballHome extends StatefulWidget {
  @override
  _BasketballHomeState createState() => _BasketballHomeState();
}

class _BasketballHomeState extends State<BasketballHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HomeCell(
          text: 'New Game',
          imageName: 'pic_basketball_new_game.png',
          function: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BasketballNewGame()));
          },
        ),
        SizedBox(
          height: 20,
        ),
        HomeCell(
          text: 'View Roster',
          imageName: 'pic_basketball_new_roster.png',
          function: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ViewBasketballRosterPage()));
          },
        ),
        SizedBox(
          height: 20,
        ),
        HomeCell(
          text: 'View Game / Stats',
          imageName: 'pic_basketball_view_game_stats.png',
          function: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BasketballStatsHistoryPage()));
          },
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
