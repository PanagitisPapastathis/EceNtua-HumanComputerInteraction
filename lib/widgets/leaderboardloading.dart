import 'package:flutter/material.dart';

class LeaderboardLoading extends StatelessWidget {
  const LeaderboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100, height: 100,
        child: CircularProgressIndicator(
          strokeWidth: 10,
          valueColor: AlwaysStoppedAnimation(Colors.black.withOpacity((0.5))),
        ),

      ),
      
    );
  }
}