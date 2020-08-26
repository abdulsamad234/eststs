import 'package:estats/pages/coach/new_game/football_action_page.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class BasketballGamePointCard extends StatelessWidget {
  final int point;
  final List<Map<String, dynamic>> players;
  final bool isOnBreak;
  final bool isOpponent;
  final Function onPressed;
  BasketballGamePointCard(
      {@required this.point,
      this.players,
      this.isOnBreak,
      this.isOpponent = false,
      this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: !this.isOpponent ? Color(0xFF31AC8D) : Color(0xFFF4072D),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Center(
          child: Text(
            this.point > 1 ? '${this.point} points' : '${this.point} point',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
