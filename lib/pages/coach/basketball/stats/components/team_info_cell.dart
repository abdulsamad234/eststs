import 'package:flutter/material.dart';

class TeamInfoCell extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool flipped;
  TeamInfoCell({this.title, this.subtitle, this.flipped = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     color: this.flipped ? Color(0xFFF8F8F8) : Color(0xFFFFFFFF)),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                fontWeight: FontWeight.w500, color: Color(0xFF001937), fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
