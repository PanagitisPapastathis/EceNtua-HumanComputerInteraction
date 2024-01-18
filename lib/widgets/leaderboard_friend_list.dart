import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'leaderboardFriendlist.dart';

import '../models/leaderboardmodel.dart';
import 'leaderboardloading.dart';

class LeaderboardFriendPanel extends StatelessWidget{
  const LeaderboardFriendPanel ({super.key});
  @override
  Widget build(BuildContext context){
    LeaderboardService leaderboardService = Provider.of<LeaderboardService>(context, listen:false);

    return FutureBuilder(
      future: leaderboardService.getFriends(),
      builder: (context, snapshot){
        Widget? returningWidget;
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            returningWidget = const LeaderboardLoading();
            //Center(child: Text('waiting...'));
            break;
          case ConnectionState.done:
            var playerFriends = snapshot.data as List<leaderboard>;
            returningWidget = LeaderboardfriendList(
                player_friends: playerFriends
            );
            break;
          default:
            returningWidget = const LeaderboardLoading();
            break;
        }
        return returningWidget;
      },
    );
  }
}