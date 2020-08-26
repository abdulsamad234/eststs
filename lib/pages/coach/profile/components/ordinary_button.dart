import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class OrdinaryButton extends StatelessWidget {
  final String text;
  final double height;
  final Color bgColor;
  final String title;
  final Function onPressed;
  final TextEditingController controller;

  const OrdinaryButton(
      {Key key,
       this.text,
      this.height = 50.0,
      this.bgColor = whiteColor,
      this.title,
      this.onPressed,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                // padding: EdgeInsets.symmetric(horizontal: 20),
                height: height,
                decoration: BoxDecoration(
                    color: this.bgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      onPressed(context);
                    },
                    child: Row(
                      children: <Widget>[
                        //78, 233, 31
                        Text(this.title,
                            style: TextStyle(
                                color: Color(0xFFCFD9E2),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 17)),
                        Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none),
                                controller: controller,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: darkBGColor,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(color: Color(0xFFDDE4EB)),
              ),
            )
          ],
        ),
      ],
    );
  }
}
