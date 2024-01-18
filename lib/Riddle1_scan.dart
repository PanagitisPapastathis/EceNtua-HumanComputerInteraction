
/*import 'package:flutter/material.dart';
import 'package:treasurehunt/widgets/qrScan.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Riddle1_scan(),
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

class Riddle1_scan extends StatelessWidget {
  const Riddle1_scan({super.key});

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
              //top starths here
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
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Reggae One'),
                ),
              ),
              Positioned(
                left: 100,
                top: 70,
                child: Text(
                  'lvl $level',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Reggae One'),
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
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontFamily: 'Reggae One'),
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
              //top ends here
              const Positioned(
                left: 50,
                top: 165,
                child: Text(
                  'NtuaHunt',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Reggae One',
                  ),
                ),
              ),
              Positioned(
                top: 250,
                left: 3,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/riddles.png',
                      width: 405,
                      height: 380,
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            constraints:
                            const BoxConstraints(maxWidth: 280, maxHeight: 300),
                            child: const Text(
                              'Your dynamic text here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28.0,
                                fontFamily: 'Reggae One',
                                // You can set other text styles here
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                left: 10,
                top: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageButton_1('Back', 'assets/Home 1.png'),
                  ],
                ),
              ),
              Positioned(
                left: 40,
                top: 650,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ImageButton(
                        'Scan QR Code',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QRCodeScanner()),
                          );
                        },
                      )

                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 278,
                top: 750,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ImageButton_submit('Submit'),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 330,
                top: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('  '),
                    SizedBox(height: 20),
                    CustomImageButton(),
                  ],
                ),
              ),
            ],
          );
        },
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
                        fontFamily: 'Reggae One',
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



class ImageButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  ImageButton(this.label, {required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 350,
        height: 100,
        child: Stack(
          children: [
            Image.asset(
              'assets/wood texture 3.png',
              width: 350,
              height: 81,
              fit: BoxFit.cover,
            ),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 20,
                  fontFamily: 'Reggae One',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ImageButton_submit extends StatelessWidget {
  final String label;

  const ImageButton_submit(this.label, {super.key});

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
          width: 100,
          height: 30,
          child: Stack(
            children: [
              Image.asset(
                'assets/wood texture 6.png',
                width: 100,
                height: 30,
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
                        fontSize: 18,
                        fontFamily: 'Reggae One',
                      ),
                    ),
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

//for the hint
class CustomImageButton extends StatelessWidget {
  const CustomImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show the dialog when the image button is tapped
        _showDialog(context);
      },
      child: Image.asset(
        'assets/lamp.png', // Replace with your image asset path
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    bool boughtHint = false;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buy Hint'),
          content: Column(
            children: [
              const Text('Do you want to buy a hint for 10 diamonds?'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageButton('assets/wood texture 6.png', 'Yes', () {
                    // Handle 'Yes' button tap
                    //Navigator.of(context).pop(); // Close the dialog
                    // Add your logic for 'Yes' button action
                    boughtHint = true;
                    _showHintDialog(context, boughtHint);
                  }),
                  _buildImageButton('assets/wood texture 6.png', 'No', () {
                    // Handle 'No' button tap
                    Navigator.of(context).pop(); // Close the dialog
                    // Add your logic for 'No' button action
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showHintDialog(BuildContext context, bool boughtHint) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hint'),
          content: Column(
            children: [
              Text(boughtHint
                  ? 'Congratulations! Here is your hint text.'
                  : 'You didn\'t buy the hint.'),
              const SizedBox(height: 20),
              _buildImageButton('assets/wood texture 6.png', 'Close', () {
                Navigator.of(context).pop(); // Close the hint dialog
                Navigator.of(context).pop(); // Close the buy hint dialog
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageButton(String imagePath, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 80,
            height: 30,
            fit: BoxFit.cover,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontFamily: 'Reggae One',
            ),
          ),
        ],
      ),
    );
  }
}
*/