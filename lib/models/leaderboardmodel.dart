import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class leaderboard{
  final String id;
  final String name;
  final int level;
  final String icon;

  leaderboard({
    required this.id,
    required this.name,
    required this.level,
    required this.icon,
  });

  factory leaderboard.fromJson(Map<String, dynamic> json, String docId){
    return leaderboard(
        id: docId,
        name: json['name'],
        level: json['level'],
        icon: json['icon']
    );
  }

}


class LeaderboardService extends ChangeNotifier{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<leaderboard> players = [];
  List<leaderboard> player_friends = [];

  Future<List<String>> getCurrentUserFriendList() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>?;
        List<String> friendList = List<String>.from(data?['friendList'] ?? []);
        return friendList;
      }
    }
    return [];
  }

  Future<List<leaderboard>> getFriends() async {
    Completer<List<leaderboard>> friendsCompleter = Completer();

    try {
      // Get the current user's friend list
      List<String> friendList = await getCurrentUserFriendList();

      // Fetch all players
      var playerDocs = await firestore.collection('leaderboard').get();
      players = playerDocs.docs
          .map((p) => leaderboard.fromJson(p.data(), p.id))
          .toList();

      // Filter the players who are in the friend list
      player_friends = players.where((player) => friendList.contains(player.id)).toList();
      player_friends.sort((a, b) => b.level.compareTo(a.level));
      friendsCompleter.complete(player_friends);
    } catch (e) {
      print('Error fetching friends: $e');
      friendsCompleter.completeError(e);
    }

    return friendsCompleter.future;
  }

  Future<List<leaderboard>>getPlayers() async{
    Completer<List<leaderboard>> playerCompleter = Completer();

    try {
      var playerDocs = await firestore.collection('leaderboard').get();
      players = playerDocs.docs
          .map((p) => leaderboard.fromJson(p.data(), p.id))
          .toList();

      // Sort players based on their level in descending order
      players.sort((a, b) => b.level.compareTo(a.level));

      List<String> friend;
      List<String> friendList = await getCurrentUserFriendList();
      player_friends = players.where((player) => friendList.contains(player.id)).toList();

      playerCompleter.complete(players);
    } catch (e) {
      print('Error fetching players: $e');
      playerCompleter.completeError(e);
    }

    return playerCompleter.future;
  }
}