import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class LiveGameCell extends StatelessWidget {
  int firstTeamScore;
  int secondTeamScore;
  String firstTeamName;
  String secondTeamName;
  String firstTeamImage;
  String secondTeamImage;
  final Function onTap;
  final String date;
  LiveGameCell(
      {
      this.firstTeamImage,
      this.firstTeamName,
      this.firstTeamScore,
      this.secondTeamImage,
      this.secondTeamName,
      this.secondTeamScore,
      this.onTap,
      this.date,
      });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
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
                              image: this.firstTeamImage == null
                                  ? AssetImage(
                                      'assets/packers_logo.png',
                                    )
                                  : NetworkImage(this.firstTeamImage),
                              fit: BoxFit.contain)),
                    ),
                    Text(
                      '${this.firstTeamName}',
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
                      '${this.firstTeamScore} : ${this.secondTeamScore}',
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
                              image: this.secondTeamImage == null || this.secondTeamImage == ''
                                  ? AssetImage(
                                      'assets/generic_icon.png',
                                    )
                                  : NetworkImage(this.secondTeamImage),
                              fit: BoxFit.contain)),
                    ),
                    Text(
                      '${this.secondTeamName}',
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
        SizedBox(
          height: 25,
        )
      ],
    );
  }
}
