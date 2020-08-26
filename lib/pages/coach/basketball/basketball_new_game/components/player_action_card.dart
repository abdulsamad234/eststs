import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/new_game/football_action_page.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class PlayerActionCard extends StatelessWidget {
  final Player player;
  final isSelected;
  final Function onTap;
  final int index;
  PlayerActionCard({this.player, this.isSelected = false, this.onTap, this.index});
  @override
  Widget build(BuildContext context) {
    return 
    Expanded(
      child: GestureDetector(
        onTap: (){
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
          child: this.player != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '#${player.number}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: darkBGColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            '${player.firstName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: darkBGColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${player.lastName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: darkBGColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Container(),
        ),
        ),
      // ),
    );
  }
}
