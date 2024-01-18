import 'package:flutter/material.dart';
import '../models/leaderboardmodel.dart';
import 'leaderboardPlayer.dart';

class LeaderboardList extends StatelessWidget{

  final List<leaderboard> players;
  const LeaderboardList({super.key, required this.players});



  @override
  Widget build(BuildContext context) {
    return (
      Expanded(
        child: ListView.builder(
          itemCount: players.length,
            itemBuilder: ((context, index){
              var player = players[index];
              return Player_Leaderboard(player.name, player.icon, player.level);
            })
        ),
       )
    );
  }
}


