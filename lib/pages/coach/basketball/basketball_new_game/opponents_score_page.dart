import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/components/player_action_bottom.dart';
import 'package:estats/pages/coach/new_game/components/player_action_card.dart';
import 'package:estats/pages/coach/new_game/components/select_score_card.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OpponentsScorePage extends StatefulWidget {
  final String title;
  OpponentsScorePage({this.title = 'Opponents Score'});
  @override
  _OpponentsScorePageState createState() => _OpponentsScorePageState();
}

class _OpponentsScorePageState extends State<OpponentsScorePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  int quarterNumber = 1;
  int currentSelectedScore = 0;
  List<bool> scoreSelected = [false, false, false, false];

  _buildScoreBoards(index) {
    int index1 = (index * 2);
    int index2 = (index * 2 + 1);
    print('Index 1: $index1');
    print('Index 2: $index2');
    return Row(
      children: <Widget>[
        SelectScoreCard(
          isSelected: scoreSelected[index1],
          onTap: selectScoreButton,
          index: index1,
          childText: index1 == 0 ? '1' : '3',
        ),
        SizedBox(
          width: 15,
        ),
        SelectScoreCard(
          isSelected: scoreSelected[index2],
          onTap: selectScoreButton,
          index: index2,
          childText: index2 == 1 ? '2' : '6',
        ),
      ],
    );
  }

  selectScoreButton(int index) {
    for (int i = 0; i < scoreSelected.length; i++) {
      setState(() {
        scoreSelected[i] = false;
      });
    }
    setState(() {
      scoreSelected[index] = true;
      currentSelectedScore =
          index == 0 ? 1 : index == 1 ? 2 : index == 2 ? 3 : 6;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          leading: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: darkBGColor,
                            ),
                          ),
                          title: Text(
                            '${widget.title}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: darkBGColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: List.generate(2, (index1) {
                            return Column(
                              children: <Widget>[
                                _buildScoreBoards(index1),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                PlayerActionBottom(
                  actionType: widget.title,
                  opponentScore:
                      currentSelectedScore == 0 ? null : currentSelectedScore,
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
          isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      backgroundColor: mainBGColor,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
