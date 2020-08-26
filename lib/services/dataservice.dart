import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataService {
  Future<Map<String, dynamic>> getCurrentUserData() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot docSnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .get();
    return docSnap.data;
  }

  Future<void> updateCurrentUserData(Map<String, dynamic> userData) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .updateData(userData);
  }

  Future<bool> addPlayer(Map<String, dynamic> data) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding player...');
    QuerySnapshot snapHere = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('players')
        .where('number', isEqualTo: data['number'])
        .getDocuments();
    if (snapHere.documents.length > 0) {
      return false;
    }
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('players')
        .add(data);
    return true;
  }

  Future<bool> addBasketballPlayer(Map<String, dynamic> data) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding player...');
    QuerySnapshot snapHere = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballPlayers')
        .where('number', isEqualTo: data['number'])
        .getDocuments();
    if (snapHere.documents.length > 0) {
      return false;
    }
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballPlayers')
        .add(data);
    return true;
  }

  Future<String> addAction(Map<String, dynamic> data, String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding action...');
    DocumentReference ref = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .document(gameId)
        .collection('actions')
        .add(data);
    return ref.documentID;
  }

  Future<void> deleteAction(String actionId, String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding action...');
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .document(gameId)
        .collection('actions')
        .document(actionId)
        .delete();
  }

  Future<String> addBasketballAction(
      Map<String, dynamic> data, String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding action...');
    String docId = (await Firestore.instance
            .collection('users')
            .document('${currentUser.uid}')
            .collection('basketballGames')
            .document(gameId)
            .collection('actions')
            .add(data))
        .documentID;
    return docId;
  }

  Future<void> deleteBasketballAction(String actionId, String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding action...');
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballGames')
        .document(gameId)
        .collection('actions')
        .document(actionId)
        .delete();
  }

  Future<void> savePlayer(Map<String, dynamic> data, String documentId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding player...');
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('players')
        .document(documentId)
        .updateData(data);
  }

  Future<void> saveBasketballPlayer(
      Map<String, dynamic> data, String documentId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding player...');
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballPlayers')
        .document(documentId)
        .updateData(data);
  }

  Future<void> deletePlayer(String documentId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    print('Adding player...');

    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('players')
        .document(documentId)
        .delete();
  }

  Future<List<Map<String, dynamic>>> getPlayers() async {
    List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    QuerySnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('players')
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['documentId'] = qrySnapDocuments[i].documentID;
      players.add(currentData);
    }
    return players;
  }

  Future<List<Map<String, dynamic>>> getBasketballPlayers() async {
    List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    QuerySnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballPlayers')
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['documentId'] = qrySnapDocuments[i].documentID;
      players.add(currentData);
    }
    return players;
  }

  Future<List<String>> getSchools() async {
    List<String> schools = List<String>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    // bool doesNotContain = false;
    QuerySnapshot qrySnap =
        await Firestore.instance.collection('users').getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      if (currentData['isCoach'] == true) {
        schools.add(currentData['schoolName']);
      }
    }
    return schools;
  }

  Future<List<Map<String, dynamic>>> getAllGames() async {
    List<Map<String, dynamic>> games = List<Map<String, dynamic>>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    QuerySnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .orderBy('startTime', descending: true)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['documentId'] = qrySnapDocuments[i].documentID;
      games.add(currentData);
    }
    return games;
  }

  Future<List<Map<String, dynamic>>> getAllFanGames() async {
    List<Map<String, dynamic>> games = List<Map<String, dynamic>>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .get();
    String schoolName = qrySnap.data['schoolName'];
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    QuerySnapshot gamesSnap = await Firestore.instance
        .collection('users')
        .document('${coachSnap.documents[0].documentID}')
        .collection('games')
        .orderBy('startTime', descending: true)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = gamesSnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['documentId'] = qrySnapDocuments[i].documentID;
      currentData['imageUrl'] = coachSnap.documents[0].data['imageUrl'];
      currentData['teamName'] = coachSnap.documents[0].data['teamName'];
      games.add(currentData);
    }
    return games;
  }

  Future<List<Map<String, dynamic>>> getAllFanGamesSearch(
      String schoolName) async {
    List<Map<String, dynamic>> games = List<Map<String, dynamic>>();
    // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    // DocumentSnapshot qrySnap = await Firestore.instance
    //     .collection('users')
    //     .document('${currentUser.uid}')
    //     .get();
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    QuerySnapshot gamesSnap = await Firestore.instance
        .collection('users')
        .document('${coachSnap.documents[0].documentID}')
        .collection('games')
        .orderBy('startTime', descending: true)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = gamesSnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['documentId'] = qrySnapDocuments[i].documentID;
      currentData['imageUrl'] = coachSnap.documents[0].data['imageUrl'];
      currentData['teamName'] = coachSnap.documents[0].data['teamName'];
      games.add(currentData);
    }
    return games;
  }

  Future<List<Map<String, dynamic>>> getAllFanBasketballGames() async {
    List<Map<String, dynamic>> games = List<Map<String, dynamic>>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .get();
    String schoolName = qrySnap.data['schoolName'];
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    QuerySnapshot gamesSnap = await Firestore.instance
        .collection('users')
        .document('${coachSnap.documents[0].documentID}')
        .collection('basketballGames')
        .orderBy('startTime', descending: true)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = gamesSnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['documentId'] = qrySnapDocuments[i].documentID;
      currentData['teamName'] = coachSnap.documents[0].data['teamName'];
      currentData['basketballPicUrl'] =
          coachSnap.documents[0].data['basketballPicUrl'];
      games.add(currentData);
    }
    return games;
  }

  Future<List<Map<String, dynamic>>> getAllFanBasketballGamesSearch(
      String schoolName) async {
    List<Map<String, dynamic>> games = List<Map<String, dynamic>>();
    // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    // // DocumentSnapshot qrySnap = await Firestore.instance
    // //     .collection('users')
    // //     .document('${currentUser.uid}')
    // //     .get();
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    QuerySnapshot gamesSnap = await Firestore.instance
        .collection('users')
        .document('${coachSnap.documents[0].documentID}')
        .collection('basketballGames')
        .orderBy('startTime', descending: true)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = gamesSnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['documentId'] = qrySnapDocuments[i].documentID;
      currentData['teamName'] = coachSnap.documents[0].data['teamName'];
      currentData['basketballPicUrl'] =
          coachSnap.documents[0].data['basketballPicUrl'];
      games.add(currentData);
    }
    return games;
  }

  Future<Map<String, dynamic>> getPlayerStats(String playerId) async {
    Map<String, dynamic> playerStats = Map<String, dynamic>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('players')
        .document('$playerId')
        .get();
    playerStats['player'] = qrySnap.data;
    playerStats['playerId'] = playerId;
    playerStats['total_pass'] = 0;
    playerStats['completed_pass'] = 0;
    playerStats['pass_yards'] = 0;
    playerStats['intercepted_pass'] = 0;
    playerStats['touchdown_pass'] = 0;
    playerStats['pass_catches'] = 0;
    playerStats['catch_yards'] = 0;
    playerStats['catch_touchdowns'] = 0;
    playerStats['runs'] = 0;
    playerStats['run_yards'] = 0;
    playerStats['run_touchdown'] = 0;
    playerStats['tackles'] = 0;
    playerStats['sacks'] = 0;
    playerStats['intercepts'] = 0;
    playerStats['fumbles'] = 0;
    playerStats['defensive_touchdown'] = 0;
    playerStats['kr'] = 0;
    playerStats['kr_yards'] = 0;
    playerStats['kr_touchdown'] = 0;
    playerStats['pr'] = 0;
    playerStats['pr_yards'] = 0;
    playerStats['pr_touchdown'] = 0;
    playerStats['fg'] = 0;
    playerStats['xp'] = 0;
    playerStats['fg_attempted'] = 0;
    playerStats['xp_attempted'] = 0;

    QuerySnapshot gamesQrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .getDocuments();
    // List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = gamesQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['gameId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('playerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      QuerySnapshot returnerQrySnap = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('returnerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      QuerySnapshot receiverQrySnap = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('receiverNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      print('Receiver number here is: ${qrySnap.data['number']}');
      List<DocumentSnapshot> returnerQrySnapDocuments =
          returnerQrySnap.documents;
      List<DocumentSnapshot> receiverQrySnapDocuments =
          receiverQrySnap.documents;
      print('Receiver data: ${receiverQrySnapDocuments}');
      for (int j = 0; j < returnerQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = returnerQrySnapDocuments[j].data;
        currentOne['actionId'] = returnerQrySnapDocuments[j].documentID;
        if (currentOne.containsKey('touchdown')) {
          if (currentOne['touchdown'] == 'DTD') {
            playerStats['defensive_touchdown'] =
                playerStats['defensive_touchdown'] + 1;
          }
        }
        actions.add(currentOne);
      }

      for (int j = 0; j < receiverQrySnapDocuments.length; j++) {
        print('Got into one receiver qry');
        Map<String, dynamic> currentOne = receiverQrySnapDocuments[j].data;
        currentOne['actionId'] = receiverQrySnapDocuments[j].documentID;
        playerStats['pass_catches'] = playerStats['pass_catches'] + 1;
        playerStats['catch_yards'] += currentOne['yards'];
        if (currentOne.containsKey('touchdown')) {
          playerStats['catch_touchdowns'] += 1;
        }
        actions.add(currentOne);
      }
      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          //  if (currentOne.containsKey('touchdown')) {
          //     if (currentOne['touchdown'] == 'TD') {
          //       currentData['touchdown'] = currentData['touchdown'] + 1;
          //     }
          //   }
          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'DTD')
              playerStats['defensive_touchdown'] += 1;
          }

          if (currentOne['action_type'] == 'Sack') {
            playerStats['sacks'] += 1;
          }

          if (currentOne['action_type'] == 'Run') {
            playerStats['runs'] += 1;
            if (currentOne.containsKey('yards')) {
              playerStats['run_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('touchdown')) {
              playerStats['run_touchdown'] += 1;
            }
          }

          // if (currentOne['action_type'] == 'Pass') {
          //   currentData['pass'] = currentData['pass'] + currentOne['yards'];
          // }

          if (currentOne['action_type'] == 'Fumble') {
            playerStats['fumbles'] += 1;
          }

          if (currentOne['action_type'] == 'Tackle') {
            playerStats['tackles'] += 1;
          }

          if (currentOne['action_type'] == 'Kick') {
            if (currentOne['kick_status'] == 'fg_missed' ||
                currentOne['kick_status'] == 'fg_made') {
              playerStats['fg_attempted'] += 1;
              if (currentOne['kick_status'] == 'fg_made') {
                playerStats['fg'] += 1;
              }
            }
            if (currentOne['kick_status'] == 'xp_missed' ||
                currentOne['kick_status'] == 'xp_made') {
              playerStats['xp_attempted'] += 1;
              if (currentOne['kick_status'] == 'xp_made') {
                playerStats['xp'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Pass') {
            playerStats['total_pass'] = playerStats['total_pass'] + 1;
            if (currentOne.containsKey('yards')) {
              playerStats['pass_yards'] =
                  playerStats['pass_yards'] + currentOne['yards'];
            }
            if (currentOne.containsKey('receiverNumber')) {
              playerStats['completed_pass'] = playerStats['completed_pass'] + 1;
            }
            if (currentOne.containsKey('status')) {
              if (currentOne['status'] == 'intercepted') {
                playerStats['intercepted_pass'] =
                    playerStats['intercepted_pass'] + 1;
              }
            }
            if (currentOne.containsKey('touchdown')) {
              playerStats['touchdown_pass'] = playerStats['touchdown_pass'] + 1;
            }
          }

          if (currentOne['action_type'] == 'Intercept') {
            playerStats['intercepts'] += 1;
          }

          // if (currentOne['action_type'] == 'Return') {
          //   currentData['interception'] = currentData['interception'] + 1;
          // }
          if (currentOne['action_type'] == 'Return') {
            if (currentOne['type_of_return'] == 'PR') {
              playerStats['pr'] += 1;
              if (currentOne.containsKey('yards')) {
                playerStats['pr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                playerStats['pr_touchdown'] += 1;
              }
            }
            if (currentOne['type_of_return'] == 'KR') {
              playerStats['kr'] += 1;
              if (currentOne.containsKey('yards')) {
                playerStats['kr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                playerStats['kr_touchdown'] += 1;
              }
            }
          }
          actions.add(currentOne);
        }
      }

      currentData['actions'] = actions;
    }
    return playerStats;
  }

  Future<Map<String, dynamic>> getPlayerStatsFan(String playerId) async {
    Map<String, dynamic> playerStats = Map<String, dynamic>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot qrySnap11 = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .get();
    String schoolName = qrySnap11.data['schoolName'];
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments11 = coachSnap.documents;
    if (qrySnapDocuments11.length == 0) {
      return null;
    }
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('players')
        .document('$playerId')
        .get();
    playerStats['player'] = qrySnap.data;
    playerStats['playerId'] = playerId;
    playerStats['total_pass'] = 0;
    playerStats['completed_pass'] = 0;
    playerStats['pass_yards'] = 0;
    playerStats['intercepted_pass'] = 0;
    playerStats['touchdown_pass'] = 0;
    playerStats['pass_catches'] = 0;
    playerStats['catch_yards'] = 0;
    playerStats['catch_touchdowns'] = 0;
    playerStats['runs'] = 0;
    playerStats['run_yards'] = 0;
    playerStats['run_touchdown'] = 0;
    playerStats['tackles'] = 0;
    playerStats['sacks'] = 0;
    playerStats['intercepts'] = 0;
    playerStats['fumbles'] = 0;
    playerStats['defensive_touchdown'] = 0;
    playerStats['kr'] = 0;
    playerStats['kr_yards'] = 0;
    playerStats['kr_touchdown'] = 0;
    playerStats['pr'] = 0;
    playerStats['pr_yards'] = 0;
    playerStats['pr_touchdown'] = 0;
    playerStats['fg'] = 0;
    playerStats['xp'] = 0;
    playerStats['fg_attempted'] = 0;
    playerStats['xp_attempted'] = 0;

    QuerySnapshot gamesQrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('games')
        .getDocuments();
    // List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = gamesQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['gameId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('playerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      QuerySnapshot returnerQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('returnerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      QuerySnapshot receiverQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('receiverNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      List<DocumentSnapshot> returnerQrySnapDocuments =
          returnerQrySnap.documents;
      List<DocumentSnapshot> receiverQrySnapDocuments =
          receiverQrySnap.documents;

      for (int j = 0; j < returnerQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = returnerQrySnapDocuments[j].data;
        currentOne['actionId'] = returnerQrySnapDocuments[j].documentID;
        if (currentOne.containsKey('touchdown')) {
          if (currentOne['touchdown'] == 'DTD') {
            playerStats['defensive_touchdown'] =
                playerStats['defensive_touchdown'] + 1;
          }
        }
        actions.add(currentOne);
      }

      for (int j = 0; j < receiverQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = receiverQrySnapDocuments[j].data;
        currentOne['actionId'] = receiverQrySnapDocuments[j].documentID;
        playerStats['pass_catches'] = playerStats['pass_catches'] + 1;
        playerStats['catch_yards'] += currentOne['yards'];
        if (currentOne.containsKey('touchdown')) {
          playerStats['catch_touchdowns'] += 1;
        }
        actions.add(currentOne);
      }

      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          //  if (currentOne.containsKey('touchdown')) {
          //     if (currentOne['touchdown'] == 'TD') {
          //       currentData['touchdown'] = currentData['touchdown'] + 1;
          //     }
          //   }
          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'DTD')
              playerStats['defensive_touchdown'] += 1;
          }

          if (currentOne['action_type'] == 'Sack') {
            playerStats['sacks'] += 1;
          }

          if (currentOne['action_type'] == 'Run') {
            playerStats['runs'] += 1;
            if (currentOne.containsKey('yards')) {
              playerStats['run_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('touchdown')) {
              playerStats['run_touchdown'] += 1;
            }
          }

          // if (currentOne['action_type'] == 'Pass') {
          //   currentData['pass'] = currentData['pass'] + currentOne['yards'];
          // }

          if (currentOne['action_type'] == 'Fumble') {
            playerStats['fumbles'] += 1;
          }

          if (currentOne['action_type'] == 'Tackle') {
            playerStats['tackles'] += 1;
          }

          if (currentOne['action_type'] == 'Kick') {
            if (currentOne['kick_status'] == 'fg_missed' ||
                currentOne['kick_status'] == 'fg_made') {
              playerStats['fg_attempted'] += 1;
              if (currentOne['kick_status'] == 'fg_made') {
                playerStats['fg'] += 1;
              }
            }
            if (currentOne['kick_status'] == 'xp_missed' ||
                currentOne['kick_status'] == 'xp_made') {
              playerStats['xp_attempted'] += 1;
              if (currentOne['kick_status'] == 'xp_made') {
                playerStats['xp'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Pass') {
            playerStats['total_pass'] = playerStats['total_pass'] + 1;
            if (currentOne.containsKey('yards')) {
              playerStats['pass_yards'] =
                  playerStats['pass_yards'] + currentOne['yards'];
            }
            if (currentOne.containsKey('receiverNumber')) {
              playerStats['completed_pass'] = playerStats['completed_pass'] + 1;
            }
            if (currentOne.containsKey('status')) {
              if (currentOne['status'] == 'intercepted') {
                playerStats['intercepted_pass'] =
                    playerStats['intercepted_pass'] + 1;
              }
            }
            if (currentOne.containsKey('touchdown')) {
              playerStats['touchdown_pass'] = playerStats['touchdown_pass'] + 1;
            }
          }

          if (currentOne['action_type'] == 'Intercept') {
            playerStats['intercepts'] += 1;
          }

          // if (currentOne['action_type'] == 'Return') {
          //   currentData['interception'] = currentData['interception'] + 1;
          // }

          if (currentOne['action_type'] == 'Return') {
            if (currentOne['type_of_return'] == 'PR') {
              playerStats['pr'] += 1;
              if (currentOne.containsKey('yards')) {
                playerStats['pr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                playerStats['pr_touchdown'] += 1;
              }
            }
            if (currentOne['type_of_return'] == 'KR') {
              playerStats['kr'] += 1;
              if (currentOne.containsKey('yards')) {
                playerStats['kr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                playerStats['kr_touchdown'] += 1;
              }
            }
          }

          actions.add(currentOne);
        }
      }

      currentData['actions'] = actions;
    }
    return playerStats;
  }

  Future<Map<String, dynamic>> getPlayerStatsFanSearch(
      String playerId, String schoolName) async {
    Map<String, dynamic> playerStats = Map<String, dynamic>();
    // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    // DocumentSnapshot qrySnap11 = await Firestore.instance
    //     .collection('users')
    //     .document('${currentUser.uid}')
    //     .get();
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments11 = coachSnap.documents;
    if (qrySnapDocuments11.length == 0) {
      return null;
    }
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('players')
        .document('$playerId')
        .get();
    playerStats['player'] = qrySnap.data;
    playerStats['playerId'] = playerId;
    playerStats['total_pass'] = 0;
    playerStats['completed_pass'] = 0;
    playerStats['pass_yards'] = 0;
    playerStats['intercepted_pass'] = 0;
    playerStats['touchdown_pass'] = 0;
    playerStats['pass_catches'] = 0;
    playerStats['catch_yards'] = 0;
    playerStats['catch_touchdowns'] = 0;
    playerStats['runs'] = 0;
    playerStats['run_yards'] = 0;
    playerStats['run_touchdown'] = 0;
    playerStats['tackles'] = 0;
    playerStats['sacks'] = 0;
    playerStats['intercepts'] = 0;
    playerStats['fumbles'] = 0;
    playerStats['defensive_touchdown'] = 0;
    playerStats['kr'] = 0;
    playerStats['kr_yards'] = 0;
    playerStats['kr_touchdown'] = 0;
    playerStats['pr'] = 0;
    playerStats['pr_yards'] = 0;
    playerStats['pr_touchdown'] = 0;
    playerStats['fg'] = 0;
    playerStats['xp'] = 0;
    playerStats['fg_attempted'] = 0;
    playerStats['xp_attempted'] = 0;

    QuerySnapshot gamesQrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('games')
        .getDocuments();
    // List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = gamesQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['gameId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('playerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      QuerySnapshot returnerQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('returnerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      QuerySnapshot receiverQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('receiverNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      List<DocumentSnapshot> returnerQrySnapDocuments =
          returnerQrySnap.documents;
      List<DocumentSnapshot> receiverQrySnapDocuments =
          receiverQrySnap.documents;

      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          //  if (currentOne.containsKey('touchdown')) {
          //     if (currentOne['touchdown'] == 'TD') {
          //       currentData['touchdown'] = currentData['touchdown'] + 1;
          //     }
          //   }

          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'DTD')
              playerStats['defensive_touchdown'] += 1;
          }

          if (currentOne['action_type'] == 'Sack') {
            playerStats['sacks'] += 1;
          }

          if (currentOne['action_type'] == 'Run') {
            playerStats['runs'] += 1;
            if (currentOne.containsKey('yards')) {
              playerStats['run_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('touchdown')) {
              playerStats['run_touchdown'] += 1;
            }
          }

          // if (currentOne['action_type'] == 'Pass') {
          //   currentData['pass'] = currentData['pass'] + currentOne['yards'];
          // }

          if (currentOne['action_type'] == 'Fumble') {
            playerStats['fumbles'] += 1;
          }

          if (currentOne['action_type'] == 'Tackle') {
            playerStats['tackles'] += 1;
          }

          if (currentOne['action_type'] == 'Kick') {
            if (currentOne['kick_status'] == 'fg_missed' ||
                currentOne['kick_status'] == 'fg_made') {
              playerStats['fg_attempted'] += 1;
              if (currentOne['kick_status'] == 'fg_made') {
                playerStats['fg'] += 1;
              }
            }
            if (currentOne['kick_status'] == 'xp_missed' ||
                currentOne['kick_status'] == 'xp_made') {
              playerStats['xp_attempted'] += 1;
              if (currentOne['kick_status'] == 'xp_made') {
                playerStats['xp'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Pass') {
            playerStats['total_pass'] = playerStats['total_pass'] + 1;
            if (currentOne.containsKey('yards')) {
              playerStats['pass_yards'] =
                  playerStats['pass_yards'] + currentOne['yards'];
            }
            if (currentOne.containsKey('receiverNumber')) {
              playerStats['completed_pass'] = playerStats['completed_pass'] + 1;
            }
            if (currentOne.containsKey('status')) {
              if (currentOne['status'] == 'intercepted') {
                playerStats['intercepted_pass'] =
                    playerStats['intercepted_pass'] + 1;
              }
            }
            if (currentOne.containsKey('touchdown')) {
              playerStats['touchdown_pass'] = playerStats['touchdown_pass'] + 1;
            }
          }

          if (currentOne['action_type'] == 'Intercept') {
            playerStats['intercepts'] += 1;
          }

          // if (currentOne['action_type'] == 'Return') {
          //   currentData['interception'] = currentData['interception'] + 1;
          // }
          if (currentOne['action_type'] == 'Return') {
            if (currentOne['type_of_return'] == 'PR') {
              playerStats['pr'] += 1;
              if (currentOne.containsKey('yards')) {
                playerStats['pr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                playerStats['pr_touchdown'] += 1;
              }
            }
            if (currentOne['type_of_return'] == 'KR') {
              playerStats['kr'] += 1;
              if (currentOne.containsKey('yards')) {
                playerStats['kr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                playerStats['kr_touchdown'] += 1;
              }
            }
          }

          actions.add(currentOne);
        }

        for (int j = 0; j < returnerQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = returnerQrySnapDocuments[j].data;
          currentOne['actionId'] = returnerQrySnapDocuments[j].documentID;
          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'DTD') {
              playerStats['defensive_touchdown'] =
                  playerStats['defensive_touchdown'] + 1;
            }
          }
          actions.add(currentOne);
        }

        for (int j = 0; j < receiverQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = receiverQrySnapDocuments[j].data;
          currentOne['actionId'] = receiverQrySnapDocuments[j].documentID;
          playerStats['pass_catches'] = playerStats['pass_catches'] + 1;
          playerStats['catch_yards'] += currentOne['yards'];
          if (currentOne.containsKey('touchdown')) {
            playerStats['catch_touchdowns'] += 1;
          }
          actions.add(currentOne);
        }
      }

      currentData['actions'] = actions;
    }
    return playerStats;
  }

  Future<Map<String, dynamic>> getBasketballPlayerStats(String playerId) async {
    Map<String, dynamic> playerStats = Map<String, dynamic>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballPlayers')
        .document('$playerId')
        .get();
    playerStats['player'] = qrySnap.data;
    playerStats['playerId'] = playerId;
    playerStats['games_played'] = 0;
    playerStats['points'] = 0;
    playerStats['field_goals_made'] = 0;
    playerStats['field_goals_attempted'] = 0;
    playerStats['field_goals_percentage'] = 0;
    playerStats['three_pointers_made'] = 0;
    playerStats['three_pointers_attempted'] = 0;
    playerStats['three_pointers_percentage'] = 0;
    playerStats['free_throws_made'] = 0;
    playerStats['free_throws_attempted'] = 0;
    playerStats['free_throws_percentage'] = 0;
    playerStats['rebounds'] = 0;
    playerStats['offensive_rebounds'] = 0;
    playerStats['assists'] = 0;
    playerStats['turnovers'] = 0;
    playerStats['steals'] = 0;
    playerStats['blocks'] = 0;
    playerStats['fouls'] = 0;

    QuerySnapshot gamesQrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballGames')
        .getDocuments();
    // List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = gamesQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['gameId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('basketballGames')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('playerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;

      if (actionQrySnapDocuments.length == 0) {
      } else {
        playerStats['games_played'] += 1;
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          if (currentOne['action_type'] == 'Score') {
            if (currentOne['status'] == 'made') {
              playerStats['points'] += currentOne['points'];
              
              if (currentOne['points'] == 3) {
                playerStats['three_pointers_made'] += 1;
                playerStats['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                playerStats['free_throws_made'] += 1;
                playerStats['free_throws_attempted'] += 1;
              }
              else{
                playerStats['field_goals_made'] += 1;
                playerStats['field_goals_attempted'] += 1;
              }
            } else {
              if (currentOne['points'] == 3) {
                playerStats['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                playerStats['free_throws_attempted'] += 1;
              }
              else{
                playerStats['field_goals_attempted'] += 1;
              }
            }
            
          }

          if (currentOne['action_type'] == 'Rebound') {
            playerStats['rebounds'] += 1;
            if (currentOne['rebound_type'] == 'offensive') {
              playerStats['offensive_rebounds'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Assist') {
            playerStats['assists'] += 1;
          }

          if (currentOne['action_type'] == 'Steal') {
            playerStats['steals'] += 1;
          }

          if (currentOne['action_type'] == 'Block') {
            playerStats['blocks'] += 1;
          }

          if (currentOne['action_type'] == 'Foul') {
            playerStats['fouls'] += 1;
          }

          if (currentOne['action_type'] == 'Turnover') {
            playerStats['turnovers'] += 1;
          }

          actions.add(currentOne);
        }

        playerStats['three_pointers_percentage'] =
            playerStats['three_pointers_made'] /
                playerStats['three_pointers_attempted'];
        playerStats['free_throws_percentage'] =
            playerStats['free_throws_made'] /
                playerStats['free_throws_attempted'];

        playerStats['field_goals_percentage'] =
            playerStats['field_goals_made'] /
                playerStats['field_goals_attempted'];
      }

      currentData['actions'] = actions;
    }
    return playerStats;
  }

  Future<Map<String, dynamic>> getBasketballPlayerStatsFan(
      String playerId) async {
    Map<String, dynamic> playerStats = Map<String, dynamic>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot qrySnap11 = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .get();
    String schoolName = qrySnap11.data['schoolName'];
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments11 = coachSnap.documents;
    if (qrySnapDocuments11.length == 0) {
      return null;
    }
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('basketballPlayers')
        .document('$playerId')
        .get();
    playerStats['player'] = qrySnap.data;
    playerStats['playerId'] = playerId;
    playerStats['games_played'] = 0;
    playerStats['points'] = 0;
    playerStats['field_goals_made'] = 0;
    playerStats['field_goals_attempted'] = 0;
    playerStats['field_goals_percentage'] = 0;
    playerStats['three_pointers_made'] = 0;
    playerStats['three_pointers_attempted'] = 0;
    playerStats['three_pointers_percentage'] = 0;
    playerStats['free_throws_made'] = 0;
    playerStats['free_throws_attempted'] = 0;
    playerStats['free_throws_percentage'] = 0;
    playerStats['rebounds'] = 0;
    playerStats['offensive_rebounds'] = 0;
    playerStats['assists'] = 0;
    playerStats['turnovers'] = 0;
    playerStats['steals'] = 0;
    playerStats['blocks'] = 0;
    playerStats['fouls'] = 0;

    QuerySnapshot gamesQrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('basketballGames')
        .getDocuments();
    // List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = gamesQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['gameId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('basketballGames')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('playerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;

      if (actionQrySnapDocuments.length == 0) {
      } else {
        playerStats['games_played'] += 1;
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          if (currentOne['action_type'] == 'Score') {
            if (currentOne['status'] == 'made') {
              playerStats['points'] += currentOne['points'];
              if (currentOne['points'] == 3) {
                playerStats['three_pointers_made'] += 1;
                playerStats['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                playerStats['free_throws_made'] += 1;
                playerStats['free_throws_attempted'] += 1;
              }
              else{
                playerStats['field_goals_made'] += 1;
                playerStats['field_goals_attempted'] += 1;
              }
            } else {
              if (currentOne['points'] == 3) {
                playerStats['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                playerStats['free_throws_attempted'] += 1;
              }
              else{
                playerStats['field_goals_attempted'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Rebound') {
            playerStats['rebounds'] += 1;
            if (currentOne['rebound_type'] == 'offensive') {
              playerStats['offensive_rebounds'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Assist') {
            playerStats['assists'] += 1;
          }

          if (currentOne['action_type'] == 'Steal') {
            playerStats['steals'] += 1;
          }

          if (currentOne['action_type'] == 'Block') {
            playerStats['blocks'] += 1;
          }

          if (currentOne['action_type'] == 'Foul') {
            playerStats['fouls'] += 1;
          }

          if (currentOne['action_type'] == 'Turnover') {
            playerStats['turnovers'] += 1;
          }

          actions.add(currentOne);
        }

        playerStats['three_pointers_percentage'] =
            playerStats['three_pointers_made'] /
                playerStats['three_pointers_attempted'];
        playerStats['free_throws_percentage'] =
            playerStats['free_throws_made'] /
                playerStats['free_throws_attempted'];

        playerStats['field_goals_percentage'] =
            playerStats['field_goals_made'] /
                playerStats['field_goals_attempted'];
      }

      currentData['actions'] = actions;
    }
    return playerStats;
  }

  Future<Map<String, dynamic>> getBasketballPlayerStatsFanSearch(
      String playerId, String schoolName) async {
    Map<String, dynamic> playerStats = Map<String, dynamic>();
    // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments11 = coachSnap.documents;
    if (qrySnapDocuments11.length == 0) {
      return null;
    }
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('basketballPlayers')
        .document('$playerId')
        .get();
    playerStats['player'] = qrySnap.data;
    playerStats['playerId'] = playerId;
    playerStats['games_played'] = 0;
    playerStats['points'] = 0;
    playerStats['field_goals_made'] = 0;
    playerStats['field_goals_attempted'] = 0;
    playerStats['field_goals_percentage'] = 0;
    playerStats['three_pointers_made'] = 0;
    playerStats['three_pointers_attempted'] = 0;
    playerStats['three_pointers_percentage'] = 0;
    playerStats['free_throws_made'] = 0;
    playerStats['free_throws_attempted'] = 0;
    playerStats['free_throws_percentage'] = 0;
    playerStats['rebounds'] = 0;
    playerStats['offensive_rebounds'] = 0;
    playerStats['assists'] = 0;
    playerStats['turnovers'] = 0;
    playerStats['steals'] = 0;
    playerStats['blocks'] = 0;
    playerStats['fouls'] = 0;

    QuerySnapshot gamesQrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('basketballGames')
        .getDocuments();
    // List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = gamesQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['gameId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('basketballGames')
          .document('${qrySnapDocuments[i].documentID}')
          .collection('actions')
          .where('playerNumber', isEqualTo: qrySnap.data['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;

      if (actionQrySnapDocuments.length == 0) {
      } else {
        playerStats['games_played'] += 1;
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          if (currentOne['action_type'] == 'Score') {
            if (currentOne['status'] == 'made') {
              playerStats['points'] += currentOne['points'];

              if (currentOne['points'] == 3) {
                playerStats['three_pointers_made'] += 1;
                playerStats['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                playerStats['free_throws_made'] += 1;
                playerStats['free_throws_attempted'] += 1;
              }
              else{
                playerStats['field_goals_made'] += 1;
                playerStats['field_goals_attempted'] += 1;
              }
            } else {
              if (currentOne['points'] == 3) {
                playerStats['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                playerStats['free_throws_attempted'] += 1;
              }
              else{
                playerStats['field_goals_attempted'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Rebound') {
            playerStats['rebounds'] += 1;
            if (currentOne['rebound_type'] == 'offensive') {
              playerStats['offensive_rebounds'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Assist') {
            playerStats['assists'] += 1;
          }

          if (currentOne['action_type'] == 'Steal') {
            playerStats['steals'] += 1;
          }

          if (currentOne['action_type'] == 'Block') {
            playerStats['blocks'] += 1;
          }

          if (currentOne['action_type'] == 'Foul') {
            playerStats['fouls'] += 1;
          }

          if (currentOne['action_type'] == 'Turnover') {
            playerStats['turnovers'] += 1;
          }

          actions.add(currentOne);
        }

        playerStats['three_pointers_percentage'] =
            playerStats['three_pointers_made'] /
                playerStats['three_pointers_attempted'];
        playerStats['free_throws_percentage'] =
            playerStats['free_throws_made'] /
                playerStats['free_throws_attempted'];

        playerStats['field_goals_percentage'] =
            playerStats['field_goals_made'] /
                playerStats['field_goals_attempted'];
      }

      currentData['actions'] = actions;
    }
    return playerStats;
  }

  Future<Map<String, dynamic>> getBasketballGameStat(String gameId) async {
    Map<String, dynamic> gameStat = Map<String, dynamic>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballGames')
        .document('$gameId')
        .get();
    gameStat['game'] = qrySnap.data;
    gameStat['gameId'] = gameId;
    gameStat['points'] = 0;
    gameStat['field_goals_made'] = 0;
    gameStat['field_goals_attempted'] = 0;
    gameStat['field_goals_percentage'] = 0;
    gameStat['three_pointers_made'] = 0;
    gameStat['three_pointers_attempted'] = 0;
    gameStat['three_pointers_percentage'] = 0;
    gameStat['free_throws_made'] = 0;
    gameStat['free_throws_attempted'] = 0;
    gameStat['free_throws_percentage'] = 0;
    gameStat['rebounds'] = 0;
    gameStat['offensive_rebounds'] = 0;
    gameStat['assists'] = 0;
    gameStat['turnovers'] = 0;
    gameStat['steals'] = 0;
    gameStat['blocks'] = 0;
    gameStat['fouls'] = 0;

    QuerySnapshot playersQrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballPlayers')
        .getDocuments();
    List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = playersQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['playerId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('basketballGames')
          .document('$gameId')
          .collection('actions')
          .where('playerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      currentData['points'] = 0;
      currentData['field_goals_made'] = 0;
      currentData['field_goals_attempted'] = 0;
      currentData['field_goals_percentage'] = 0;
      currentData['three_pointers_made'] = 0;
      currentData['three_pointers_attempted'] = 0;
      currentData['three_pointers_percentage'] = 0;
      currentData['free_throws_made'] = 0;
      currentData['free_throws_attempted'] = 0;
      currentData['free_throws_percentage'] = 0;
      currentData['rebounds'] = 0;
      currentData['offensive_rebounds'] = 0;
      currentData['assists'] = 0;
      currentData['turnovers'] = 0;
      currentData['steals'] = 0;
      currentData['blocks'] = 0;
      currentData['fouls'] = 0;
      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          if (currentOne['action_type'] == 'Score') {
            if (currentOne['status'] == 'made') {
              currentData['points'] =
                  currentData['points'] + currentOne['points'];
              gameStat['points'] += currentOne['points'];
              
              if (currentOne['points'] == 3) {
                currentData['three_pointers_made'] += 1;
                gameStat['three_pointers_made'] += 1;
                currentData['three_pointers_attempted'] += 1;
                gameStat['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                currentData['free_throws_made'] += 1;
                gameStat['free_throws_made'] += 1;
                currentData['free_throws_attempted'] += 1;
                gameStat['free_throws_attempted'] += 1;
              }
              else{
                currentData['field_goals_made'] += 1;
                gameStat['field_goals_made'] += 1;
                currentData['field_goals_attempted'] += 1;
                gameStat['field_goals_attempted'] += 1;
              }
            } else {
              if (currentOne['points'] == 3) {
                currentData['three_pointers_attempted'] += 1;
                gameStat['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                currentData['free_throws_attempted'] += 1;
                gameStat['free_throws_attempted'] += 1;
              }
              else{
                currentData['field_goals_attempted'] += 1;
                gameStat['field_goals_attempted'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Rebound') {
            gameStat['rebounds'] += 1;
            currentData['rebounds'] += 1;
            if (currentOne['rebound_type'] == 'offensive') {
              gameStat['offensive_rebounds'] += 1;
              currentData['offensive_rebounds'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Assist') {
            gameStat['assists'] += 1;
            currentData['rebounds'] += 1;
          }

          if (currentOne['action_type'] == 'Steal') {
            gameStat['steals'] += 1;
            currentData['rebounds'] += 1;
          }

          if (currentOne['action_type'] == 'Block') {
            gameStat['blocks'] += 1;
            currentData['rebounds'] += 1;
          }

          if (currentOne['action_type'] == 'Foul') {
            gameStat['fouls'] += 1;
            currentData['rebounds'] += 1;
          }

          if (currentOne['action_type'] == 'Turnover') {
            gameStat['turnovers'] += 1;
            currentData['rebounds'] += 1;
          }

          actions.add(currentOne);
        }

        currentData['three_pointers_percentage'] =
            currentData['three_pointers_made'] /
                currentData['three_pointers_attempted'];
        gameStat['three_pointers_percentage'] =
            gameStat['three_pointers_made'] /
                gameStat['three_pointers_attempted'];
        currentData['free_throws_percentage'] =
            currentData['free_throws_made'] /
                currentData['free_throws_attempted'];
        gameStat['free_throws_percentage'] =
            gameStat['free_throws_made'] / gameStat['free_throws_attempted'];
        currentData['field_goals_percentage'] =
            currentData['field_goals_made'] /
                currentData['field_goals_attempted'];
        gameStat['field_goals_percentage'] =
            gameStat['field_goals_made'] / gameStat['field_goals_attempted'];
      }

      currentData['actions'] = actions;
      players.add(currentData);
    }
    gameStat['players'] = players;
    return gameStat;
  }

  Future<Map<String, dynamic>> getBasketballGameStatFan(String gameId) async {
    Map<String, dynamic> gameStat = Map<String, dynamic>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot qrySnap11 = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .get();
    String schoolName = qrySnap11.data['schoolName'];
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments11 = coachSnap.documents;
    if (qrySnapDocuments11.length == 0) {
      return null;
    }
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('basketballGames')
        .document('$gameId')
        .get();
    gameStat['game'] = qrySnap.data;
    gameStat['gameId'] = gameId;
    gameStat['points'] = 0;
    gameStat['field_goals_made'] = 0;
    gameStat['field_goals_attempted'] = 0;
    gameStat['field_goals_percentage'] = 0;
    gameStat['three_pointers_made'] = 0;
    gameStat['three_pointers_attempted'] = 0;
    gameStat['three_pointers_percentage'] = 0;
    gameStat['free_throws_made'] = 0;
    gameStat['free_throws_attempted'] = 0;
    gameStat['free_throws_percentage'] = 0;
    gameStat['rebounds'] = 0;
    gameStat['offensive_rebounds'] = 0;
    gameStat['assists'] = 0;
    gameStat['turnovers'] = 0;
    gameStat['steals'] = 0;
    gameStat['blocks'] = 0;
    gameStat['fouls'] = 0;

    QuerySnapshot playersQrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('basketballPlayers')
        .getDocuments();
    List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = playersQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['playerId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('basketballGames')
          .document('$gameId')
          .collection('actions')
          .where('playerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      currentData['points'] = 0;
      currentData['field_goals_made'] = 0;
      currentData['field_goals_attempted'] = 0;
      currentData['field_goals_percentage'] = 0;
      currentData['three_pointers_made'] = 0;
      currentData['three_pointers_attempted'] = 0;
      currentData['three_pointers_percentage'] = 0;
      currentData['free_throws_made'] = 0;
      currentData['free_throws_attempted'] = 0;
      currentData['free_throws_percentage'] = 0;
      currentData['rebounds'] = 0;
      currentData['offensive_rebounds'] = 0;
      currentData['assists'] = 0;
      currentData['turnovers'] = 0;
      currentData['steals'] = 0;
      currentData['blocks'] = 0;
      currentData['fouls'] = 0;
      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          if (currentOne['action_type'] == 'Score') {
            if (currentOne['status'] == 'made') {
              currentData['points'] =
                  currentData['points'] + currentOne['points'];
              gameStat['points'] += currentOne['points'];
              if (currentOne['points'] == 3) {
                currentData['three_pointers_made'] += 1;
                gameStat['three_pointers_made'] += 1;
                currentData['three_pointers_attempted'] += 1;
                gameStat['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                currentData['free_throws_made'] += 1;
                gameStat['free_throws_made'] += 1;
                currentData['free_throws_attempted'] += 1;
                gameStat['free_throws_attempted'] += 1;
              }
              else{
                currentData['field_goals_made'] += 1;
                gameStat['field_goals_made'] += 1;
                currentData['field_goals_attempted'] += 1;
                gameStat['field_goals_attempted'] += 1;
              }
            } else {
              if (currentOne['points'] == 3) {
                currentData['three_pointers_attempted'] += 1;
                gameStat['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                currentData['free_throws_attempted'] += 1;
                gameStat['free_throws_attempted'] += 1;
              }
              else{
                currentData['field_goals_attempted'] += 1;
                gameStat['field_goals_attempted'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Rebound') {
            gameStat['rebounds'] += 1;
            currentData['rebounds'] += 1;
            if (currentOne['rebound_type'] == 'offensive') {
              gameStat['offensive_rebounds'] += 1;
              currentData['offensive_rebounds'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Assist') {
            gameStat['assists'] += 1;
            currentData['assists'] += 1;
          }

          if (currentOne['action_type'] == 'Steal') {
            gameStat['steals'] += 1;
            currentData['steals'] += 1;
          }

          if (currentOne['action_type'] == 'Block') {
            gameStat['blocks'] += 1;
            currentData['blocks'] += 1;
          }

          if (currentOne['action_type'] == 'Foul') {
            gameStat['fouls'] += 1;
            currentData['fouls'] += 1;
          }

          if (currentOne['action_type'] == 'Turnover') {
            gameStat['turnovers'] += 1;
            currentData['turnovers'] += 1;
          }

          actions.add(currentOne);
        }

        currentData['three_pointers_percentage'] =
            currentData['three_pointers_made'] /
                currentData['three_pointers_attempted'];
        gameStat['three_pointers_percentage'] =
            gameStat['three_pointers_made'] /
                gameStat['three_pointers_attempted'];
        currentData['free_throws_percentage'] =
            currentData['free_throws_made'] /
                currentData['free_throws_attempted'];
        gameStat['free_throws_percentage'] =
            gameStat['free_throws_made'] / gameStat['free_throws_attempted'];
        currentData['field_goals_percentage'] =
            currentData['field_goals_made'] /
                currentData['field_goals_attempted'];
        gameStat['field_goals_percentage'] =
            gameStat['field_goals_made'] / gameStat['field_goals_attempted'];
      }

      currentData['actions'] = actions;
      players.add(currentData);
    }
    gameStat['players'] = players;
    return gameStat;
  }

  Future<Map<String, dynamic>> getBasketballGameStatFanSearch(
      String gameId, String schoolName) async {
    Map<String, dynamic> gameStat = Map<String, dynamic>();
    // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    // DocumentSnapshot qrySnap11 = await Firestore.instance
    //     .collection('users')
    //     .document('${currentUser.uid}')
    //     .get();
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments11 = coachSnap.documents;
    if (qrySnapDocuments11.length == 0) {
      return null;
    }
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('basketballGames')
        .document('$gameId')
        .get();
    gameStat['game'] = qrySnap.data;
    gameStat['gameId'] = gameId;
    gameStat['points'] = 0;
    gameStat['field_goals_made'] = 0;
    gameStat['field_goals_attempted'] = 0;
    gameStat['field_goals_percentage'] = 0;
    gameStat['three_pointers_made'] = 0;
    gameStat['three_pointers_attempted'] = 0;
    gameStat['three_pointers_percentage'] = 0;
    gameStat['free_throws_made'] = 0;
    gameStat['free_throws_attempted'] = 0;
    gameStat['free_throws_percentage'] = 0;
    gameStat['rebounds'] = 0;
    gameStat['offensive_rebounds'] = 0;
    gameStat['assists'] = 0;
    gameStat['turnovers'] = 0;
    gameStat['steals'] = 0;
    gameStat['blocks'] = 0;
    gameStat['fouls'] = 0;
    

    QuerySnapshot playersQrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('basketballPlayers')
        .getDocuments();
    List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = playersQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['playerId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('basketballGames')
          .document('$gameId')
          .collection('actions')
          .where('playerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      currentData['points'] = 0;
      currentData['field_goals_made'] = 0;
      currentData['field_goals_attempted'] = 0;
      currentData['field_goals_percentage'] = 0;
      currentData['three_pointers_made'] = 0;
      currentData['three_pointers_attempted'] = 0;
      currentData['three_pointers_percentage'] = 0;
      currentData['free_throws_made'] = 0;
      currentData['free_throws_attempted'] = 0;
      currentData['free_throws_percentage'] = 0;
      currentData['rebounds'] = 0;
      currentData['offensive_rebounds'] = 0;
      currentData['assists'] = 0;
      currentData['turnovers'] = 0;
      currentData['steals'] = 0;
      currentData['blocks'] = 0;
      currentData['fouls'] = 0;
      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          // if (currentOne.containsKey('touchdown')) {
          //   if (currentOne['touchdown'] == 'TD') {
          //     currentData['touchdown'] = currentData['touchdown'] + 1;
          //   }
          // }

          if (currentOne['action_type'] == 'Score') {
            if (currentOne['status'] == 'made') {
              currentData['points'] =
                  currentData['points'] + currentOne['points'];
              gameStat['points'] += currentOne['points'];
              if (currentOne['points'] == 3) {
                currentData['three_pointers_made'] += 1;
                gameStat['three_pointers_made'] += 1;
                currentData['three_pointers_attempted'] += 1;
                gameStat['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                currentData['free_throws_made'] += 1;
                gameStat['free_throws_made'] += 1;
                currentData['free_throws_attempted'] += 1;
                gameStat['free_throws_attempted'] += 1;
              }
              else{
                currentData['field_goals_made'] += 1;
                gameStat['field_goals_made'] += 1;
                currentData['field_goals_attempted'] += 1;
                gameStat['field_goals_attempted'] += 1;
              }
            } else {
              if (currentOne['points'] == 3) {
                currentData['three_pointers_attempted'] += 1;
                gameStat['three_pointers_attempted'] += 1;
              }
              if (currentOne['points'] == 1) {
                currentData['free_throws_attempted'] += 1;
                gameStat['free_throws_attempted'] += 1;
              }
              else{
                currentData['field_goals_attempted'] += 1;
                gameStat['field_goals_attempted'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Rebound') {
            gameStat['rebounds'] += 1;
            currentData['rebounds'] += 1;
            if (currentOne['rebound_type'] == 'offensive') {
              gameStat['offensive_rebounds'] += 1;
              currentData['offensive_rebounds'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Assist') {
            gameStat['assists'] += 1;
            currentData['assists'] += 1;
          }

          if (currentOne['action_type'] == 'Steal') {
            gameStat['steals'] += 1;
            currentData['steals'] += 1;
          }

          if (currentOne['action_type'] == 'Block') {
            gameStat['blocks'] += 1;
            currentData['blocks'] += 1;
          }

          if (currentOne['action_type'] == 'Foul') {
            gameStat['fouls'] += 1;
            currentData['fouls'] += 1;
          }

          if (currentOne['action_type'] == 'Turnover') {
            gameStat['turnovers'] += 1;
            currentData['turnovers'] += 1;
          }

          actions.add(currentOne);
        }

        currentData['three_pointers_percentage'] =
            currentData['three_pointers_made'] /
                currentData['three_pointers_attempted'];
        gameStat['three_pointers_percentage'] =
            gameStat['three_pointers_made'] /
                gameStat['three_pointers_attempted'];
        currentData['free_throws_percentage'] =
            currentData['free_throws_made'] /
                currentData['free_throws_attempted'];
        gameStat['free_throws_percentage'] =
            gameStat['free_throws_made'] / gameStat['free_throws_attempted'];
        currentData['field_goals_percentage'] =
            currentData['field_goals_made'] /
                currentData['field_goals_attempted'];
        gameStat['field_goals_percentage'] =
            gameStat['field_goals_made'] / gameStat['field_goals_attempted'];
      }

      currentData['actions'] = actions;
      players.add(currentData);
    }
    gameStat['players'] = players;
    return gameStat;
  }

  Future<Map<String, dynamic>> getGameStat(String gameId) async {
    Map<String, dynamic> gameStat = Map<String, dynamic>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .document('$gameId')
        .get();
    gameStat['game'] = qrySnap.data;
    gameStat['gameId'] = gameId;
    gameStat['team_total_pass'] = 0;
    gameStat['team_completed_pass'] = 0;
    gameStat['team_pass_yards'] = 0;
    gameStat['team_intercepted_pass'] = 0;
    gameStat['team_touchdown_pass'] = 0;
    gameStat['team_pass_catches'] = 0;
    gameStat['team_catch_yards'] = 0;
    gameStat['team_catch_touchdowns'] = 0;
    gameStat['team_runs'] = 0;
    gameStat['team_run_yards'] = 0;
    gameStat['team_run_touchdown'] = 0;
    gameStat['team_tackles'] = 0;
    gameStat['team_sacks'] = 0;
    gameStat['team_intercepts'] = 0;
    gameStat['team_fumbles'] = 0;

    QuerySnapshot playersQrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('players')
        .getDocuments();
    List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = playersQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['playerId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('playerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      QuerySnapshot returnerQrySnap = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('returnerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      QuerySnapshot receiverQrySnap = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('receiverNumber', isEqualTo: currentData['number']).where('action_type', isEqualTo: 'Pass')
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      List<DocumentSnapshot> returnerQrySnapDocuments =
          returnerQrySnap.documents;
      List<DocumentSnapshot> receiverQrySnapDocuments =
          receiverQrySnap.documents;
      currentData['comp'] = 0;
      currentData['pass'] = 0;
      currentData['pass_yards'] = 0;
      currentData['pass_touchdown'] = 0;
      currentData['intercepted'] = 0;
      currentData['carries'] = 0;
      currentData['carry_yards'] = 0;
      currentData['carry_touchdown'] = 0;
      currentData['received'] = 0;
      currentData['received_yards'] = 0;
      currentData['received_touchdown'] = 0;
      currentData['kr'] = 0;
      currentData['kr_yards'] = 0;
      currentData['kr_touchdown'] = 0;
      currentData['pr'] = 0;
      currentData['pr_yards'] = 0;
      currentData['pr_touchdown'] = 0;
      currentData['fg'] = 0;
      currentData['xp'] = 0;
      currentData['fg_attempted'] = 0;
      currentData['xp_attempted'] = 0;
      currentData['forced_fumble'] = 0;
      currentData['touchdown'] = 0;
      currentData['defensive_touchdown'] = 0;
      currentData['tackle'] = 0;
      currentData['sack'] = 0;
      currentData['interception'] = 0;
      for (int j = 0; j < returnerQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = returnerQrySnapDocuments[j].data;
        currentOne['actionId'] = returnerQrySnapDocuments[j].documentID;
        if (currentOne.containsKey('touchdown')) {
          if (currentOne['touchdown'] == 'DTD') {
            currentData['defensive_touchdown'] =
                currentData['defensive_touchdown'] + 1;
          }
        }
        actions.add(currentOne);
      }

      for (int j = 0; j < receiverQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = receiverQrySnapDocuments[j].data;
        currentOne['actionId'] = receiverQrySnapDocuments[j].documentID;
        gameStat['team_pass_catches'] = gameStat['team_pass_catches'] + 1;
        gameStat['team_catch_yards'] += currentOne['yards'];
        currentData['received'] += 1;
        currentData['received_yards'] += currentOne['yards'];
        if (currentOne.containsKey('touchdown')) {
          gameStat['team_catch_touchdowns'] += 1;
          currentData['received_touchdown'] += 1;
        }
        actions.add(currentOne);
      }
      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'TD') {
              currentData['touchdown'] = currentData['touchdown'] + 1;
            }
          }

          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'DTD') {
              currentData['defensive_touchdown'] =
                  currentData['defensive_touchdown'] + 1;
            }
          }

          if (currentOne['action_type'] == 'Sack') {
            currentData['sack'] = currentData['sack'] + 1;
            gameStat['team_sacks'] += 1;
          }

          if (currentOne['action_type'] == 'Run') {
            currentData['carries'] += 1;

            gameStat['team_runs'] += 1;
            if (currentOne.containsKey('yards')) {
              gameStat['team_run_yards'] += currentOne['yards'];
              currentData['carry_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('touchdown')) {
              gameStat['team_run_touchdown'] += 1;
              currentData['carry_touchdown'] += 1;
            }
          }

          // if (currentOne['action_type'] == 'Pass') {
          //   currentData['pass'] = currentData['pass'] + currentOne['yards'];
          // }

          if (currentOne['action_type'] == 'Fumble') {
            currentData['forced_fumble'] = currentData['forced_fumble'] + 1;
            gameStat['team_fumbles'] += 1;
          }

          if (currentOne['action_type'] == 'Tackle') {
            currentData['tackle'] = currentData['tackle'] + 1;
            gameStat['team_tackles'] += 1;
          }

          if (currentOne['action_type'] == 'Kick') {
            if (currentOne['kick_status'] == 'fg_missed' ||
                currentOne['kick_status'] == 'fg_made') {
              currentData['fg_attempted'] += 1;
              if (currentOne['kick_status'] == 'fg_made') {
                currentData['fg'] += 1;
              }
            }
            if (currentOne['kick_status'] == 'xp_missed' ||
                currentOne['kick_status'] == 'xp_made') {
              currentData['xp_attempted'] += 1;
              if (currentOne['kick_status'] == 'xp_made') {
                currentData['xp'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Pass') {
            currentData['pass'] += 1;
            gameStat['team_total_pass'] = gameStat['team_total_pass'] + 1;
            if (currentOne.containsKey('yards')) {
              gameStat['team_pass_yards'] =
                  gameStat['team_pass_yards'] + currentOne['yards'];
              currentData['pass_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('receiverNumber')) {
              gameStat['team_completed_pass'] =
                  gameStat['team_completed_pass'] + 1;
              currentData['comp'] += 1;
            }
            if (currentOne.containsKey('status')) {
              if (currentOne['status'] == 'intercepted') {
                gameStat['team_intercepted_pass'] =
                    gameStat['team_intercepted_pass'] + 1;
                currentData['intercepted'] += 1;
              }
            }
            if (currentOne.containsKey('touchdown')) {
              gameStat['team_touchdown_pass'] =
                  gameStat['team_touchdown_pass'] + 1;
              currentData['pass_touchdown'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Intercept') {
            currentData['interception'] = currentData['interception'] + 1;
            gameStat['team_intercepts'] += 1;
          }

          if (currentOne['action_type'] == 'Return') {
            if (currentOne['type_of_return'] == 'PR') {
              currentData['pr'] += 1;
              if (currentOne.containsKey('yards')) {
                currentData['pr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                currentData['pr_touchdown'] += 1;
              }
            }
            if (currentOne['type_of_return'] == 'KR') {
              currentData['kr'] += 1;
              if (currentOne.containsKey('yards')) {
                currentData['kr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                currentData['kr_touchdown'] += 1;
              }
            }
          }

          actions.add(currentOne);
        }
      }

      currentData['actions'] = actions;
      players.add(currentData);
    }
    gameStat['players'] = players;
    return gameStat;
  }

  Future<Map<String, dynamic>> getGameStatFan(String gameId) async {
    Map<String, dynamic> gameStat = Map<String, dynamic>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot qrySnap11 = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .get();
    String schoolName = qrySnap11.data['schoolName'];
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments11 = coachSnap.documents;
    if (qrySnapDocuments11.length == 0) {
      return null;
    }
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('games')
        .document('$gameId')
        .get();
    gameStat['game'] = qrySnap.data;
    gameStat['gameId'] = gameId;
    gameStat['team_total_pass'] = 0;
    gameStat['team_completed_pass'] = 0;
    gameStat['team_pass_yards'] = 0;
    gameStat['team_intercepted_pass'] = 0;
    gameStat['team_touchdown_pass'] = 0;
    gameStat['team_pass_catches'] = 0;
    gameStat['team_catch_yards'] = 0;
    gameStat['team_catch_touchdowns'] = 0;
    gameStat['team_runs'] = 0;
    gameStat['team_run_yards'] = 0;
    gameStat['team_run_touchdown'] = 0;
    gameStat['team_tackles'] = 0;
    gameStat['team_sacks'] = 0;
    gameStat['team_intercepts'] = 0;
    gameStat['team_fumbles'] = 0;

    QuerySnapshot playersQrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('players')
        .getDocuments();
    List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = playersQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['playerId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('playerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      QuerySnapshot returnerQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('returnerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      QuerySnapshot receiverQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('receiverNumber', isEqualTo: currentData['number']).where('action_type', isEqualTo: 'Pass')
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      List<DocumentSnapshot> returnerQrySnapDocuments =
          returnerQrySnap.documents;
      List<DocumentSnapshot> receiverQrySnapDocuments =
          receiverQrySnap.documents;
      currentData['comp'] = 0;
      currentData['pass'] = 0;
      currentData['pass_yards'] = 0;
      currentData['pass_touchdown'] = 0;
      currentData['intercepted'] = 0;
      currentData['carries'] = 0;
      currentData['carry_yards'] = 0;
      currentData['carry_touchdown'] = 0;
      currentData['received'] = 0;
      currentData['received_yards'] = 0;
      currentData['received_touchdown'] = 0;
      currentData['kr'] = 0;
      currentData['kr_yards'] = 0;
      currentData['kr_touchdown'] = 0;
      currentData['pr'] = 0;
      currentData['pr_yards'] = 0;
      currentData['pr_touchdown'] = 0;
      currentData['fg'] = 0;
      currentData['xp'] = 0;
      currentData['fg_attempted'] = 0;
      currentData['xp_attempted'] = 0;
      currentData['forced_fumble'] = 0;
      currentData['touchdown'] = 0;
      currentData['defensive_touchdown'] = 0;
      currentData['tackle'] = 0;
      currentData['sack'] = 0;
      currentData['interception'] = 0;

      for (int j = 0; j < returnerQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = returnerQrySnapDocuments[j].data;
        currentOne['actionId'] = returnerQrySnapDocuments[j].documentID;
        if (currentOne.containsKey('touchdown')) {
          if (currentOne['touchdown'] == 'DTD') {
            currentData['defensive_touchdown'] =
                currentData['defensive_touchdown'] + 1;
          }
        }
        actions.add(currentOne);
      }

      for (int j = 0; j < receiverQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = receiverQrySnapDocuments[j].data;
        currentOne['actionId'] = receiverQrySnapDocuments[j].documentID;
        gameStat['team_pass_catches'] = gameStat['team_pass_catches'] + 1;
        gameStat['team_catch_yards'] += currentOne['yards'];
        currentData['received'] += 1;
        currentData['received_yards'] += currentOne['yards'];
        if (currentOne.containsKey('touchdown')) {
          gameStat['team_catch_touchdowns'] += 1;
          currentData['received_touchdown'] += 1;
        }
        actions.add(currentOne);
      }
      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'TD') {
              currentData['touchdown'] = currentData['touchdown'] + 1;
            }
          }

          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'DTD') {
              currentData['defensive_touchdown'] =
                  currentData['defensive_touchdown'] + 1;
            }
          }

          if (currentOne['action_type'] == 'Sack') {
            currentData['sack'] = currentData['sack'] + 1;
            gameStat['team_sacks'] += 1;
          }

          if (currentOne['action_type'] == 'Run') {
            currentData['carries'] += 1;
            gameStat['team_runs'] += 1;
            if (currentOne.containsKey('yards')) {
              gameStat['team_run_yards'] += currentOne['yards'];
              currentData['carry_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('touchdown')) {
              gameStat['team_run_touchdown'] += 1;
              currentData['carry_touchdown'] += 1;
            }
          }

          // if (currentOne['action_type'] == 'Pass') {
          //   currentData['pass'] = currentData['pass'] + currentOne['yards'];
          // }

          if (currentOne['action_type'] == 'Fumble') {
            currentData['forced_fumble'] = currentData['forced_fumble'] + 1;
            gameStat['team_fumbles'] += 1;
          }

          if (currentOne['action_type'] == 'Tackle') {
            currentData['tackle'] = currentData['tackle'] + 1;
            gameStat['team_tackles'] += 1;
          }

          if (currentOne['action_type'] == 'Kick') {
            if (currentOne['kick_status'] == 'fg_missed' ||
                currentOne['kick_status'] == 'fg_made') {
              currentData['fg_attempted'] += 1;
              if (currentOne['kick_status'] == 'fg_made') {
                currentData['fg'] += 1;
              }
            }
            if (currentOne['kick_status'] == 'xp_missed' ||
                currentOne['kick_status'] == 'xp_made') {
              currentData['xp_attempted'] += 1;
              if (currentOne['kick_status'] == 'xp_made') {
                currentData['xp'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Pass') {
            currentData['pass'] += 1;
            gameStat['team_total_pass'] = gameStat['team_total_pass'] + 1;
            if (currentOne.containsKey('yards')) {
              gameStat['team_pass_yards'] =
                  gameStat['team_pass_yards'] + currentOne['yards'];
              currentData['pass_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('receiverNumber')) {
              gameStat['team_completed_pass'] =
                  gameStat['team_completed_pass'] + 1;
              currentData['comp'] += 1;
            }
            if (currentOne.containsKey('status')) {
              if (currentOne['status'] == 'intercepted') {
                gameStat['team_intercepted_pass'] =
                    gameStat['team_intercepted_pass'] + 1;
                currentData['intercepted'] += 1;
              }
            }
            if (currentOne.containsKey('touchdown')) {
              gameStat['team_touchdown_pass'] =
                  gameStat['team_touchdown_pass'] + 1;
              currentData['pass_touchdown'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Intercept') {
            currentData['interception'] = currentData['interception'] + 1;
            gameStat['team_intercepts'] += 1;
          }

          if (currentOne['action_type'] == 'Return') {
            if (currentOne['type_of_return'] == 'PR') {
              currentData['pr'] += 1;
              if (currentOne.containsKey('yards')) {
                currentData['pr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                currentData['pr_touchdown'] += 1;
              }
            }
            if (currentOne['type_of_return'] == 'KR') {
              currentData['kr'] += 1;
              if (currentOne.containsKey('yards')) {
                currentData['kr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                currentData['kr_touchdown'] += 1;
              }
            }
          }

          actions.add(currentOne);
        }
      }

      currentData['actions'] = actions;
      players.add(currentData);
    }
    gameStat['players'] = players;
    return gameStat;
  }

  Future<Map<String, dynamic>> getGameStatFanSearch(
      String gameId, String schoolName) async {
    Map<String, dynamic> gameStat = Map<String, dynamic>();
    // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    // DocumentSnapshot qrySnap11 = await Firestore.instance
    //     .collection('users')
    //     .document('${currentUser.uid}')
    //     .get();
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments11 = coachSnap.documents;
    if (qrySnapDocuments11.length == 0) {
      return null;
    }
    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('games')
        .document('$gameId')
        .get();
    gameStat['game'] = qrySnap.data;
    gameStat['gameId'] = gameId;
    gameStat['team_total_pass'] = 0;
    gameStat['team_completed_pass'] = 0;
    gameStat['team_pass_yards'] = 0;
    gameStat['team_intercepted_pass'] = 0;
    gameStat['team_touchdown_pass'] = 0;
    gameStat['team_pass_catches'] = 0;
    gameStat['team_catch_yards'] = 0;
    gameStat['team_catch_touchdowns'] = 0;
    gameStat['team_runs'] = 0;
    gameStat['team_run_yards'] = 0;
    gameStat['team_run_touchdown'] = 0;
    gameStat['team_tackles'] = 0;
    gameStat['team_sacks'] = 0;
    gameStat['team_intercepts'] = 0;
    gameStat['team_fumbles'] = 0;

    QuerySnapshot playersQrySnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments11[0].documentID}')
        .collection('players')
        .getDocuments();
    List<Map<String, dynamic>> players = List<Map<String, dynamic>>();
    List<DocumentSnapshot> qrySnapDocuments = playersQrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['playerId'] = qrySnapDocuments[i].documentID;
      QuerySnapshot actionQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('playerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      QuerySnapshot returnerQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('returnerNumber', isEqualTo: currentData['number'])
          .getDocuments();
      QuerySnapshot receiverQrySnap = await Firestore.instance
          .collection('users')
          .document('${qrySnapDocuments11[0].documentID}')
          .collection('games')
          .document('$gameId')
          .collection('actions')
          .where('receiverNumber', isEqualTo: currentData['number']).where('action_type', isEqualTo: 'Pass')
          .getDocuments();
      List<Map<String, dynamic>> actions = List<Map<String, dynamic>>();
      List<DocumentSnapshot> actionQrySnapDocuments = actionQrySnap.documents;
      List<DocumentSnapshot> returnerQrySnapDocuments =
          returnerQrySnap.documents;
      List<DocumentSnapshot> receiverQrySnapDocuments =
          receiverQrySnap.documents;

      currentData['comp'] = 0;
      currentData['pass'] = 0;
      currentData['pass_yards'] = 0;
      currentData['pass_touchdown'] = 0;
      currentData['intercepted'] = 0;
      currentData['carries'] = 0;
      currentData['carry_yards'] = 0;
      currentData['carry_touchdown'] = 0;
      currentData['received'] = 0;
      currentData['received_yards'] = 0;
      currentData['received_touchdown'] = 0;
      currentData['kr'] = 0;
      currentData['kr_yards'] = 0;
      currentData['kr_touchdown'] = 0;
      currentData['pr'] = 0;
      currentData['pr_yards'] = 0;
      currentData['pr_touchdown'] = 0;
      currentData['fg'] = 0;
      currentData['xp'] = 0;
      currentData['fg_attempted'] = 0;
      currentData['xp_attempted'] = 0;
      currentData['forced_fumble'] = 0;
      currentData['touchdown'] = 0;
      currentData['defensive_touchdown'] = 0;
      currentData['tackle'] = 0;
      currentData['sack'] = 0;
      currentData['interception'] = 0;

      for (int j = 0; j < returnerQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = returnerQrySnapDocuments[j].data;
        currentOne['actionId'] = returnerQrySnapDocuments[j].documentID;
        if (currentOne.containsKey('touchdown')) {
          if (currentOne['touchdown'] == 'DTD') {
            currentData['defensive_touchdown'] =
                currentData['defensive_touchdown'] + 1;
          }
        }
        actions.add(currentOne);
      }

      for (int j = 0; j < receiverQrySnapDocuments.length; j++) {
        Map<String, dynamic> currentOne = receiverQrySnapDocuments[j].data;
        currentOne['actionId'] = receiverQrySnapDocuments[j].documentID;
        gameStat['team_pass_catches'] = gameStat['team_pass_catches'] + 1;
        gameStat['team_catch_yards'] += currentOne['yards'];
        currentData['received'] += 1;
        currentData['received_yards'] += currentOne['yards'];
        if (currentOne.containsKey('touchdown')) {
          gameStat['team_catch_touchdowns'] += 1;
          currentData['received_touchdown'] += 1;
        }
        actions.add(currentOne);
      }
      if (actionQrySnapDocuments.length == 0) {
      } else {
        for (int j = 0; j < actionQrySnapDocuments.length; j++) {
          Map<String, dynamic> currentOne = actionQrySnapDocuments[j].data;
          currentOne['actionId'] = actionQrySnapDocuments[j].documentID;
          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'TD') {
              currentData['touchdown'] = currentData['touchdown'] + 1;
            }
          }

          if (currentOne.containsKey('touchdown')) {
            if (currentOne['touchdown'] == 'DTD') {
              currentData['defensive_touchdown'] =
                  currentData['defensive_touchdown'] + 1;
            }
          }

          if (currentOne['action_type'] == 'Sack') {
            currentData['sack'] = currentData['sack'] + 1;
            gameStat['team_sacks'] += 1;
          }

          if (currentOne['action_type'] == 'Run') {
            currentData['carries'] += 1;
            gameStat['team_runs'] += 1;
            if (currentOne.containsKey('yards')) {
              gameStat['team_run_yards'] += currentOne['yards'];
              currentData['carry_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('touchdown')) {
              gameStat['team_run_touchdown'] += 1;
              currentData['carry_touchdown'] += 1;
            }
          }

          // if (currentOne['action_type'] == 'Pass') {
          //   currentData['pass'] = currentData['pass'] + currentOne['yards'];
          // }

          if (currentOne['action_type'] == 'Fumble') {
            currentData['forced_fumble'] = currentData['forced_fumble'] + 1;
            gameStat['team_fumbles'] += 1;
          }

          if (currentOne['action_type'] == 'Tackle') {
            currentData['tackle'] = currentData['tackle'] + 1;
            gameStat['team_tackles'] += 1;
          }

          if (currentOne['action_type'] == 'Pass') {
            currentData['pass'] += 1;
            gameStat['team_total_pass'] = gameStat['team_total_pass'] + 1;
            if (currentOne.containsKey('yards')) {
              gameStat['team_pass_yards'] =
                  gameStat['team_pass_yards'] + currentOne['yards'];
              currentData['pass_yards'] += currentOne['yards'];
            }
            if (currentOne.containsKey('receiverNumber')) {
              gameStat['team_completed_pass'] =
                  gameStat['team_completed_pass'] + 1;
              currentData['comp'] += 1;
            }
            if (currentOne.containsKey('status')) {
              if (currentOne['status'] == 'intercepted') {
                gameStat['team_intercepted_pass'] =
                    gameStat['team_intercepted_pass'] + 1;
                currentData['intercepted'] += 1;
              }
            }
            if (currentOne.containsKey('touchdown')) {
              gameStat['team_touchdown_pass'] =
                  gameStat['team_touchdown_pass'] + 1;
              currentData['pass_touchdown'] += 1;
            }
          }

          if (currentOne['action_type'] == 'Kick') {
            if (currentOne['kick_status'] == 'fg_missed' ||
                currentOne['kick_status'] == 'fg_made') {
              currentData['fg_attempted'] += 1;
              if (currentOne['kick_status'] == 'fg_made') {
                currentData['fg'] += 1;
              }
            }
            if (currentOne['kick_status'] == 'xp_missed' ||
                currentOne['kick_status'] == 'xp_made') {
              currentData['xp_attempted'] += 1;
              if (currentOne['kick_status'] == 'xp_made') {
                currentData['xp'] += 1;
              }
            }
          }

          if (currentOne['action_type'] == 'Pass') {
            gameStat['team_total_pass'] = gameStat['team_total_pass'] + 1;
            if (currentOne.containsKey('yards')) {
              gameStat['team_pass_yards'] =
                  gameStat['team_pass_yards'] + currentOne['yards'];
            }
            if (currentOne.containsKey('receiverNumber')) {
              gameStat['team_completed_pass'] =
                  gameStat['team_completed_pass'] + 1;
              currentData['pass'] = currentData['pass'] + 1;
            }
            if (currentOne.containsKey('status')) {
              if (currentOne['status'] == 'intercepted') {
                gameStat['team_intercepted_pass'] =
                    gameStat['team_intercepted_pass'] + 1;
              }
            }
            if (currentOne.containsKey('touchdown')) {
              gameStat['team_touchdown_pass'] =
                  gameStat['team_touchdown_pass'] + 1;
            }
          }

          if (currentOne['action_type'] == 'Intercept') {
            currentData['interception'] = currentData['interception'] + 1;
            gameStat['team_intercepts'] += 1;
          }

          // if (currentOne['action_type'] == 'Return') {
          //   currentData['interception'] = currentData['interception'] + 1;
          // }

          if (currentOne['action_type'] == 'Return') {
            if (currentOne['type_of_return'] == 'PR') {
              currentData['pr'] += 1;
              if (currentOne.containsKey('yards')) {
                currentData['pr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                currentData['pr_touchdown'] += 1;
              }
            }
            if (currentOne['type_of_return'] == 'KR') {
              currentData['kr'] += 1;
              if (currentOne.containsKey('yards')) {
                currentData['kr_yards'] += currentOne['yards'];
              }
              if (currentOne.containsKey('touchdown')) {
                currentData['kr_touchdown'] += 1;
              }
            }
          }

          actions.add(currentOne);
        }
      }

      currentData['actions'] = actions;
      players.add(currentData);
    }
    gameStat['players'] = players;
    return gameStat;
  }

  Future<List<Map<String, dynamic>>> getBasketballGames() async {
    List<Map<String, dynamic>> games = List<Map<String, dynamic>>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    QuerySnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballGames')
        .orderBy('startTime', descending: true)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      Map<String, dynamic> currentData = qrySnapDocuments[i].data;
      currentData['documentId'] = qrySnapDocuments[i].documentID;
      games.add(currentData);
    }
    return games;
  }

  Future<List<Map<String, dynamic>>> getLiveGames() async {
    List<Map<String, dynamic>> liveGames = List<Map<String, dynamic>>();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .get();
    String schoolName = qrySnap.data['schoolName'];
    QuerySnapshot coachSnap = await Firestore.instance
        .collection('users')
        .where('schoolName', isEqualTo: schoolName)
        .where('isCoach', isEqualTo: true)
        .limit(1)
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = coachSnap.documents;
    if (qrySnapDocuments.length == 0) {
      return null;
    }
    // print('Coach name: ${coachSnap.documents[0].data}');
    QuerySnapshot basketballGamesSnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments[0].documentID}')
        .collection('basketballGames')
        .getDocuments();
    for (int i = 0; i < basketballGamesSnap.documents.length; i++) {
      if (!basketballGamesSnap.documents[i].data.containsKey('endTime')) {
        liveGames.add({
          'second_team_name':
              basketballGamesSnap.documents[i].data['opponentName'],
          'second_team_score':
              basketballGamesSnap.documents[i].data['opponentPoint'],
          'team_score': basketballGamesSnap.documents[i].data['teamPoint'],
          'is_basketball': true,
          'team_name': qrySnapDocuments[0].data['teamName'],
          'team_image': qrySnapDocuments[0].data['basketballPicUrl'],
          'documentId': basketballGamesSnap.documents[i].documentID
        });
        break;
      }
    }
    QuerySnapshot gamesSnap = await Firestore.instance
        .collection('users')
        .document('${qrySnapDocuments[0].documentID}')
        .collection('games')
        .getDocuments();
    for (int i = 0; i < gamesSnap.documents.length; i++) {
      if (!gamesSnap.documents[i].data.containsKey('endTime')) {
        liveGames.add({
          'second_team_name': gamesSnap.documents[i].data['opponentName'],
          'second_team_score': gamesSnap.documents[i].data['opponentPoint'],
          'team_score': gamesSnap.documents[i].data['teamPoint'],
          'team_name': qrySnapDocuments[0].data['teamName'],
          'is_basketball': false,
          'team_image': qrySnapDocuments[0].data['imageUrl'],
          'documentId': gamesSnap.documents[i].documentID
        });
        break;
      }
    }
    return liveGames;
  }

  Future<String> createNewGameOrGetCurrentGame() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    QuerySnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      if (!qrySnapDocuments[i].data.containsKey('endTime')) {
        print('does not contain key');
        doesNotContain = true;
        return qrySnapDocuments[i].documentID;
      }
    }
    if (!doesNotContain) {
      DateTime nowTime = DateTime.now();
      DocumentReference returned = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('games')
          .add({
        'startTime': nowTime,
        '1QuarterStart': nowTime,
        'teamPoint': 0,
        'opponentPoint': 0,
        'currentQuarter': 1
      });
      return returned.documentID;
    }
  }

  Future<String> createNewGameOrGetCurrentBasketballGame() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool doesNotContain = false;
    QuerySnapshot qrySnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballGames')
        .getDocuments();
    List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      if (!qrySnapDocuments[i].data.containsKey('endTime')) {
        print('does not contain key');
        doesNotContain = true;
        return qrySnapDocuments[i].documentID;
      }
    }
    if (!doesNotContain) {
      DateTime nowTime = DateTime.now();
      DocumentReference returned = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .collection('basketballGames')
          .add({
        'startTime': nowTime,
        '1QuarterStart': nowTime,
        'teamPoint': 0,
        'opponentPoint': 0,
        'currentQuarter': 1
      });
      return returned.documentID;
    }
  }

  Future<Map<String, dynamic>> getCurrentGame(String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot docSnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .document('$gameId')
        .get();
    return docSnap.data;
  }

  Future<Map<String, dynamic>> getCurrentBasketballGame(String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot docSnap = await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballGames')
        .document('$gameId')
        .get();
    return docSnap.data;
  }

  Future<void> updateCurrentGame(
      Map<String, dynamic> gameData, String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .document('$gameId')
        .updateData(gameData);
  }

  Future<void> updateCurrentBasketballGame(
      Map<String, dynamic> gameData, String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballGames')
        .document('$gameId')
        .updateData(gameData);
  }

  Future<void> setCurrentGame(
      Map<String, dynamic> gameData, String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('games')
        .document('$gameId')
        .setData(gameData);
  }

  Future<void> setBasketballCurrentGame(
      Map<String, dynamic> gameData, String gameId) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('users')
        .document('${currentUser.uid}')
        .collection('basketballGames')
        .document('$gameId')
        .setData(gameData);
  }

  Future<bool> isGameGoingOn(String uid) async {
    // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool isGameGoingOn = false;
    List<DocumentSnapshot> qrySnapDocuments = (await Firestore.instance
            .collection('users')
            .document('${uid}')
            .collection('games')
            .getDocuments())
        .documents;
    // List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      if (!qrySnapDocuments[i].data.containsKey('endTime')) {
        print('does not contain key');
        isGameGoingOn = true;
      }
    }

    return isGameGoingOn;
  }

  Future<bool> isBasketballGameGoingOn(String uid) async {
    // FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool isGameGoingOn = false;
    List<DocumentSnapshot> qrySnapDocuments = (await Firestore.instance
            .collection('users')
            .document('${uid}')
            .collection('basketballGames')
            .getDocuments())
        .documents;
    // List<DocumentSnapshot> qrySnapDocuments = qrySnap.documents;
    for (int i = 0; i < qrySnapDocuments.length; i++) {
      if (!qrySnapDocuments[i].data.containsKey('endTime')) {
        print('does not contain key');
        isGameGoingOn = true;
      }
    }

    return isGameGoingOn;
  }

  Future<String> uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }
}
