import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class StatsHistoryCell extends StatelessWidget {
  int firstTeamScore;
  int secondTeamScore;
  String firstTeamName;
  String secondTeamName;
  String firstTeamImage;
  String secondTeamImage;
  final Function onTap;
  StatsHistoryCell(
      {this.firstTeamImage,
      this.firstTeamName,
      this.firstTeamScore,
      this.secondTeamImage,
      this.secondTeamName,
      this.secondTeamScore,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'December 22, 2019',
          style: TextStyle(
              color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            // padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      width: 90,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/packers_logo.png',
                              ),
                              fit: BoxFit.contain)),
                    ),
                    Text(
                      'Packers',
                      style: TextStyle(
                          color: darkBGColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      '0 : 1',
                      style: TextStyle(
                          color: darkBGColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      width: 90,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/toronto_logo.png',
                              ),
                              fit: BoxFit.contain)),
                    ),
                    Text(
                      'Toronto',
                      style: TextStyle(
                          color: darkBGColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 25,)
      ],
    );
  }
}
