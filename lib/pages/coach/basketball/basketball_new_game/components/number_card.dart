import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/new_game/football_action_page.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class NumberCard extends StatelessWidget {
  final Function onTap;
  final int index;
  final String childText;
  NumberCard({this.onTap, this.index, this.childText});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
          onTap: () {
            onTap(index);
          },
          child:
              //  Expanded(
              //   child:
              Container(
                  height: 65,
                  decoration: BoxDecoration(
                      color: childText == '' ? Color(0xFFF9F9F9) : greyColor,
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  child: Center(
                    child: Text(
                      '$childText',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: darkBGColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ))),
      // ),
    );
  }
}
