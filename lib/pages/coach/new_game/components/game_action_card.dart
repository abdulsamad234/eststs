import 'package:estats/common/pop_up.dart';
import 'package:estats/pages/coach/new_game/football_action_page.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class GameActionCard extends StatelessWidget {
  final String text;
  final List<Map<String, dynamic>> players;
  final bool isOnBreak;
  final String gameId;
  final int teamScore;
  final Function reload;
  GameActionCard(
      {@required this.text,
      this.players,
      this.isOnBreak,
      this.gameId,
      this.teamScore,
      this.reload});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!isOnBreak) {
          List<Map<String, dynamic>> mainPlayers = List<Map<String, dynamic>>();
          List<Map<String, dynamic>> receiverPlayers =
              List<Map<String, dynamic>>();
          List<Map<String, dynamic>> newPlayers =
              players.map((item) => item).toList();
          print('New players: $newPlayers');
          print('Number of players: ${newPlayers.length}');

          newPlayers.removeWhere((onePlayer) {
            String position = onePlayer['position'];
            if (position == 'QB - Quarterback' && this.text == 'Pass') {
              mainPlayers.add(onePlayer);
            }
            return position == 'QB - Quarterback' && this.text == 'Pass';
          });
          newPlayers.removeWhere((onePlayer) {
            String position = onePlayer['position'];
            if ((position == 'RB - Running Back' ||
                    position == 'FB - Fullback' ||
                    position == 'WR - Wide Receiver') &&
                (this.text == 'Pass' || this.text == 'Fumble')) {
              receiverPlayers.add(onePlayer);
            }
            return (position == 'RB - Running Back' ||
                    position == 'FB - Fullback' ||
                    position == 'WR - Wide Receiver') &&
                (this.text == 'Pass' || this.text == 'Fumble');
          });
          print('New player here before: $newPlayers');
          newPlayers.removeWhere((onePlayer) {
            List<dynamic> prepop = onePlayer['prepopulate'];
            if (prepop.contains(this.text)) {
              mainPlayers.add(onePlayer);
            }
            return prepop.contains(this.text);
          });
          print('New player here though: $newPlayers');
          for (int i = 0; i < newPlayers.length; i++) {
            mainPlayers.add(newPlayers[i]);
            if (this.text == 'Pass' || this.text == 'Fumble') {
              receiverPlayers.add(newPlayers[i]);
            }
          }
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => FootballActionPage(
                      title: this.text == 'Pass'
                          ? 'Select a Passer'
                          : this.text == 'Run'
                              ? 'Run'
                              : this.text == 'Kick'
                                  ? 'Kick'
                                  : this.text == 'Return'
                                      ? 'Kick Returner'
                                      : this.text == 'Tackle'
                                          ? 'Tackle by'
                                          : this.text == 'Sack'
                                              ? 'Sack by'
                                              : this.text == 'Intercept'
                                                  ? 'Interception'
                                                  : 'Forced Fumble',
                      players: mainPlayers,
                      gameId: gameId,
                      teamScore: teamScore,
                      originalText: this.text,
                      receiverPlayers: receiverPlayers,
                      isOffense: this.text == 'Pass'
                          ? true
                          : this.text == 'Run'
                              ? true
                              : this.text == 'Kick'
                                  ? true
                                  : this.text == 'Return'
                                      ? true
                                      : this.text == 'Tackle'
                                          ? false
                                          : this.text == 'Sack'
                                              ? false
                                              : this.text == 'Intercept'
                                                  ? false
                                                  : false)));
          reload();
        } else {
          showDialog(
            context: context,
            builder: (_) => PopUp(
              childWidget: Text(
                'Start the quarter to perform action',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Center(
          child: Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: darkBGColor, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
