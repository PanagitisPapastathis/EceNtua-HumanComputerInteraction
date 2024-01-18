import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'leaderboardlist.dart';

import '../models/leaderboardmodel.dart';
import 'leaderboardlist.dart';
import 'leaderboardloading.dart';

class LeaderboardPanel extends StatelessWidget{
  const LeaderboardPanel ({super.key});
  @override
  Widget build(BuildContext context){
    LeaderboardService leaderboardService = Provider.of<LeaderboardService>(context, listen:false);

    return FutureBuilder(
      future: leaderboardService.getPlayers(),
      builder: (context, snapshot){
        Widget? returningWidget;
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            returningWidget = const LeaderboardLoading();
                //Center(child: Text('waiting...'));
            break;
          case ConnectionState.done:
            var players = snapshot.data as List<leaderboard>;
            returningWidget = LeaderboardList(
              players: players
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