import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ActionBar extends StatelessWidget {
  final String title;
  final String message;
  final List<String> actionStringList;
  final List<Function> actionList;
  ActionBar({this.title = '', this.message = '', this.actionList, this.actionStringList});
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
                          title:  Text(this.title),
                          message:  Text(this.message),
                          actions: List.generate(this.actionList.length, (index){
                            return CupertinoActionSheetAction(
                              child:  Text(this.actionStringList[index]),
                              onPressed: this.actionList[index],
                            );
                          }),
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Cancel'),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                          ));
}
}