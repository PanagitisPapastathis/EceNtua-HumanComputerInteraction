import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'friends.dart';
import 'profile.dart';
import 'settings.dart';
import 'Leaderboard.dart';
import 'Riddle1_text.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(background: const Color(0xFFC1B350)),
      ),
    );
  }
}

Future<Map<String, dynamic>?> getUserData() async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>?;
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
  return null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while waiting for data
          }

          if (snapshot.hasError) {
            return const Text("Error fetching data");
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Text("No data available");
          }

          // Extracting user data from snapshot
          String nickname = snapshot.data!['nickname'] ?? 'No Nickname';
          String level = snapshot.data!['level'].toString();
          String diamonds = snapshot.data!['diamonds'].toString();
          String iconPath = snapshot.data!['profileIcon'].toString();

          return Stack(
            children: [
              Positioned(
                top: -19,
                left: -33,
                child: Image.asset(
                  'assets/wood texture 3.png',
                  width: 497,
                  height: 162,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 27,
                top: 18,
                child: Image.asset(
                  iconPath,
                  width: 65,
                  height: 78,
                ),
              ),
              Positioned(
                left: 100,
                top: 40,
                child: Text(
                  nickname,
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Positioned(
                left: 100,
                top: 70,
                child: Text(
                  'lvl $level',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              Positioned(
                left: 210,
                top: 32,
                child: Column(
                  children: [
                    SizedBox(
                      width: 280,
                      height: 53,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/Rectangle 72.png',
                            width: 95,
                            height: 53,
                          ),
                          Positioned(
                            left: 105,
                            top: 11,
                            child: Text(
                              diamonds,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 22),
                            ),
                          ),
                          Positioned(
                            left: 135,
                            top: 4,
                            child: Image.asset(
                              'assets/Game Icon 5 1.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 620),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageButton_to_Leaderboard('Leaderboard', 'assets/Leaderboard.png'),
                      SizedBox(width: 25),
                      ImageButton_to_Daily_Bonus('Daily Bonus', 'assets/Daily Challenge.png'),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 250,
                left: 0,
                child: Image.asset(
                  'assets/game selection.png', // Use the map image
                  width: 438,
                  height: 297,
                  fit: BoxFit.cover,
                ),
              ),
              //310,106
              Positioned(
                top: 310,
                left: 106,
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GameButton('Game 1', 'assets/game1.png'),
                        SizedBox(width: 15),
                        GameButton('Game 2', 'assets/game2.png'),
                        SizedBox(width: 15),
                        GameButton('Game 3', 'assets/game3.png'),
                        // Add more games as needed
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const Bottom(),
    );
  }
}

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 73,
      width: 430,
      child: Stack(
        children: [
          Positioned(
            top: 3,
            left: 0,
            child: Image.asset(
              'assets/Navigation bar.png',
              width: 435,
              height: 77,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  // Handle button tap
                },
                child: Container(
                  width: 100,
                  height: 70,
                  color: Colors.transparent,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Friends()),
                  );
                },
                child: Container(
                  width: 100,
                  height: 70,
                  color: Colors.transparent,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                child: Container(
                  width: 100,
                  height: 70,
                  color: Colors.transparent,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Ssettings()),
                  );
                },
                child: Container(
                  width: 100,
                  height: 70,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageButton_to_Leaderboard extends StatelessWidget {
  final String label;
  final String imagePath;

  const ImageButton_to_Leaderboard(this.label, this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Leaderboard()),
          );
        },
        child: SizedBox(
          width: 170,
          height: 40,
          child: Stack(
            children: [
              Image.asset(
                'assets/wood texture 3.png',
                width: 170,
                height: 40,
                fit: BoxFit.cover,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      imagePath,
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageButton_to_Daily_Bonus extends StatelessWidget {
  final String label;
  final String imagePath;

  const ImageButton_to_Daily_Bonus(this.label, this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Leaderboard()),
          );
        },
        child: SizedBox(
          width: 170,
          height: 40,
          child: Stack(
            children: [
              Image.asset(
                'assets/wood texture 3.png',
                width: 170,
                height: 40,
                fit: BoxFit.cover,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      imagePath,
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String label;
  final String imagePath;

  const GameButton(this.label, this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 226,
      height: 192,
      //decoration: BoxDecoration(
      //  border: Border.all(color: Colors.black, width: 2),
      //  borderRadius: BorderRadius.circular(10),
      //),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Riddle1_text()),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 226,
              height: 188,
              fit: BoxFit.cover,
            ),
            //SizedBox(height: 10),
            //Text(
            //  label,
            //  style: TextStyle(color: Colors.black, fontSize: 16),
            //),
          ],
        ),
      ),
    );
  }
}
