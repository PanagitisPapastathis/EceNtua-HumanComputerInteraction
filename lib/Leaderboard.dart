import 'package:flutter/material.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'widgets/leaderboard_show_list.dart';
import 'LeaderboardFriend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Leaderboard(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(background: const Color(0xFFC1B350)),
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

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
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

          const Positioned(
            left : 10,
            top: 55,
            height: 70,
            width: 200,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageButton_1('Back', 'assets/Home 1.png'),
              ],
            ),
          ),
          Positioned(
            top: 250,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 220, // Adjust height as needed
              child: const LeaderboardPanel(),
            ),
          ),
          /*const Positioned(
            left : 0,
            top: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image_Friends('Nikos', 'assets/Nikos.png', 'lvl 57'),
                SizedBox(height: 25),
                Image_Friends('John', 'assets/John.png', 'lvl 27'),
                SizedBox(height: 25),
                Image_Friends('Maria', 'assets/Maria.png', 'lvl 21'),
              ],

            ),
          ),
          */
          const Positioned(
            left : 30,
            top: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageButton_2('General'),
                SizedBox(width: 25),
                ImageButton_3('Friends'),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class ImageButton_1 extends StatelessWidget {

  final String label;
  final String imagePath;

  const ImageButton_1(this.label, this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        child: SizedBox(
          width: 180,
          height: 50,
          child: Stack(
            children: [
              Image.asset(
                'assets/wood texture 6.png',
                width: 180,
                height: 50,
                fit: BoxFit.cover,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      imagePath,
                      width: 75,
                      height: 75,
                    ),
                    const SizedBox(width: 0),
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

class ImageButton_2 extends StatelessWidget {
  final String label;
  //final String imagePath;

  const ImageButton_2(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          // Handle button tap
        },
        child: SizedBox(
          width: 166,
          height: 60,
          child: Stack(
            children: [
              Image.asset(
                'assets/wood texture 3 shadow.png',
                width: 166,
                height: 60,
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
                        fontSize: 20,
                      ),
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

class ImageButton_3 extends StatelessWidget {
  final String label;
  //final String imagePath;

  const ImageButton_3(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LeaderboardFriend()),
          );
        },
        child: SizedBox(
          width: 166,
          height: 45,
          child: Stack(
            children: [
              Image.asset(
                'assets/wood texture 3.png',
                width: 166,
                height: 60,
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
                        fontSize: 20,
                      ),
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

class Image_Friends extends StatelessWidget {

  final String label;
  final String imagePath;
  final String label2;

  const Image_Friends(this.label, this.imagePath, this.label2, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          // Handle button tap
        },
        child: SizedBox(
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Image.asset(
                      imagePath,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 30),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(width: 160),
                    Text(
                      label2,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 20),
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