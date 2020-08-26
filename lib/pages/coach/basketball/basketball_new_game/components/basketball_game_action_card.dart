import 'package:estats/common/pop_up.dart';
import 'package:estats/pages/coach/basketball/basketball_new_game/basketball_action_page.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class BasketballGameActionCard extends StatelessWidget {
  final String text;
  final List<Map<String, dynamic>> players;
  final bool isOnBreak;
  final String currentGameId;
  BasketballGameActionCard(
      {@required this.text, this.players, this.isOnBreak, this.currentGameId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isOnBreak) {
          List<Map<String, dynamic>> newPlayers =
              players.map((item) => item).toList();
          ;
          // print('New players: $newPlayers');
          // newPlayers.removeWhere((onePlayer) {
          //   List<dynamic> prepop = onePlayer['prepopulate'];
          //   print('This players prepop: $prepop');
          //   return !prepop.contains(this.text);
          // });
          Map<String, dynamic> actionData = {
            'action_type': text,
            'gameId': currentGameId,
          };

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BasketballActionPage(
                      title: this.text,
                      players: newPlayers,
                      actionData: actionData,
                      currentGameId: this.currentGameId)));
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
