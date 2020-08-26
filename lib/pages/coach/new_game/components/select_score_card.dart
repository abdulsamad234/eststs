import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/new_game/football_action_page.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class SelectScoreCard extends StatelessWidget {
  final String childText;
  final isSelected;
  final Function onTap;
  final int index;
  SelectScoreCard(
      {this.childText, this.isSelected = false, this.onTap, this.index});
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
                height: 120,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: this.isSelected ? darkerGreyColor : greyColor,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Center(
                  child: Text(
                    '$childText',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: darkBGColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                )),
      ),
      // ),
    );
  }
}
