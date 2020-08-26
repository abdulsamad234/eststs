import 'package:flutter/material.dart';

class HomeCell extends StatefulWidget {
  final String text;
  final String imageName;
  final Function function;
  HomeCell({this.text = 'Test', this.imageName, this.function});
  @override
  _HomeCellState createState() => _HomeCellState();
}

class _HomeCellState extends State<HomeCell> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.function();
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(0),
              height: 130,
              decoration: BoxDecoration(
                  color: Color(0xFF003260),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25)),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/${widget.imageName}'),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.bottomLeft)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.text,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    flex: 7,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
