import 'package:flutter/material.dart';

class Player_Leaderboard extends StatelessWidget {
  final String label;
  final String imagePath;
  final int label2;
  //final String currentUserNickname;

  const Player_Leaderboard(this.label, this.imagePath, this.label2, {super.key});

  @override
  Widget build(BuildContext context) {
    //bool isCurrentUser = label == currentUserNickname;
    return SizedBox(
      width: 418,
      height: 105,
      child: Stack(
        children: [
          Image.asset(
            'assets/friends.png',
            width: 418,
            height: 105,
            fit: BoxFit.cover,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 25,
                  ),
                ),
              ),
              const Spacer(), // This will push the level to the far right
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text(
                  '$label2',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

