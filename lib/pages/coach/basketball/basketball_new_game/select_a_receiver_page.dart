import 'package:estats/common/pop_up.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/model/player.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/new_game/components/game_action_card.dart';
import 'package:estats/pages/coach/new_game/components/player_action_bottom.dart';
import 'package:estats/pages/coach/new_game/components/player_action_card.dart';
import 'package:estats/pages/sign_up.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SelectReceiverPage extends StatefulWidget {
  final String title;
  final String originalTitle;
  SelectReceiverPage({this.title = 'Select a Receiver', this.originalTitle});
  @override
  _SelectReceiverPageState createState() => _SelectReceiverPageState();
}

class _SelectReceiverPageState extends State<SelectReceiverPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  int quarterNumber = 1;
  int firstTeamScore = 0;
  int secondTeamScore = 0;
  List<Player> initialSix = List<Player>();
  Player currentSelectedPlayer;
  List<bool> playersSelected = [false, false, false, false, false, false];

  getPlayers() {
    setState(() {
      initialSix.add(Player(firstName: 'Shawn', lastName: 'Korey', number: 87));
    });
  }

  _buildInitial(index) {
    print("Initial six: $initialSix");
    return Row(
      children: <Widget>[
        PlayerActionCard(
          isSelected: playersSelected[(index * 3)],
          onTap: selectPlayerButton,
          index: (index * 3),
          player:
              (index * 3) < initialSix.length ? initialSix[(index * 3)] : null,
        ),
        SizedBox(
          width: 15,
        ),
        PlayerActionCard(
          isSelected: playersSelected[(index * 3 + 1)],
          onTap: selectPlayerButton,
          index: (index * 3 + 1),
          player: (index * 3 + 1) < initialSix.length
              ? initialSix[(index * 3 + 1)]
              : null,
        ),
        SizedBox(
          width: 15,
        ),
        PlayerActionCard(
          isSelected: playersSelected[(index * 3 + 2)],
          onTap: selectPlayerButton,
          index: (index * 3 + 2),
          player: (index * 3 + 2) < initialSix.length
              ? initialSix[(index * 3 + 2)]
              : null,
        )
      ],
    );
  }

  selectPlayerButton(int index) {
    if (index < initialSix.length) {
      for (int i = 0; i < playersSelected.length; i++) {
        setState(() {
          playersSelected[i] = false;
        });
      }
      setState(() {
        playersSelected[index] = true;
        currentSelectedPlayer = initialSix[index];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlayers();
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
                                _buildInitial(index1),
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
