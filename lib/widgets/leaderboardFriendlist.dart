import 'package:flutter/material.dart';
import '../models/leaderboardmodel.dart';
import 'leaderboardPlayer.dart';



class LeaderboardfriendList extends StatelessWidget{

  final List<leaderboard> player_friends;
  const LeaderboardfriendList({super.key, required this.player_friends});



  @override
  Widget build(BuildContext context) {
    return (
        Expanded(
          child: ListView.builder(
              itemCount: player_friends.length,
              itemBuilder: ((context, index){
                var player = player_friends[index];
                return Player_Leaderboard(player.name, player.icon, player.level);
              })
          ),
        )
    );
  }
}
