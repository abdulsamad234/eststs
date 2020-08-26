import 'package:flutter/material.dart';

class TeamStatCell extends StatelessWidget {
  final String title;
  final String subtitle;
  TeamStatCell({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            this.title,
            style: TextStyle(
                fontWeight: FontWeight.w400, color: Color(0xFF001937)),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            this.subtitle,
            style: TextStyle(
                fontWeight: FontWeight.w400, color: Color(0xFF001937)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
