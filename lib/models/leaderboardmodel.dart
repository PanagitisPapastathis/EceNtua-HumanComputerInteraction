import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
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

  Future<List<leaderboard>>getPlayers() async{
    Completer<List<leaderboard>> playerCompleter = Completer();

    try {
      var playerDocs = await firestore.collection('leaderboard').get();
      players = playerDocs.docs
          .map((p) => leaderboard.fromJson(p.data(), p.id))
          .toList();

      // Sort players based on their level in descending order
      players.sort((a, b) => b.level.compareTo(a.level));

      playerCompleter.complete(players);
    } catch (e) {
      print('Error fetching players: $e');
      playerCompleter.completeError(e);
    }

    return playerCompleter.future;
  }
}