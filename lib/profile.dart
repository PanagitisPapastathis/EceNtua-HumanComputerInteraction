import 'package:flutter/material.dart';
import 'package:treasurehunt/home.dart';
import 'settings.dart';
import 'friends.dart';
import 'main.dart';
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
      home: const Profile(),
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
      if (userDoc.exists && userDoc.data() != null) {
        // Safely cast the data to Map<String, dynamic>
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        // Add or update the profileIcon field
        userData['profileIcon'] = userData['profileIcon'] ?? 'assets/gee_me_053.png';
        await FirebaseFirestore.instance
            .collection('leaderboard')
            .doc(currentUser.uid)
            .update({'icon': userData['profileIcon'] ?? 'assets/gee_me_053.png'});
        return userData;
      }
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
  return null;
}



class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String profileIcon = 'assets/gee_me_053.png'; // Default profile icon
  String nickname = 'nickname';
  void updateIcon(String newIconPath) {
    setState(() {
      profileIcon = newIconPath;
    });
  }
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  void fetchInitialData() async {
    var userData = await getUserData();
    if (userData != null) {
      setState(() {
        nickname = userData['nickname'] ?? 'No Nickname';
        profileIcon = userData['profileIcon'] ?? 'assets/gee_me_053.png';
      });
    }
  }

  void updateNickname(String newNickname) {
    setState(() {
      nickname = newNickname;
    });
  }

  @override
  Widget build(BuildContext context) {
    //String profileIcon = snapshot.data!['profileIcon'] ?? 'assets/gee_me_053.png';
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
          String profileIcon = snapshot.data!['profileIcon'] ?? 'assets/gee_me_053.png';
          String nickname = snapshot.data!['nickname'] ?? 'No Nickname';
          String level = snapshot.data!['level'].toString();
          String diamonds = snapshot.data!['diamonds'].toString();

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
                  profileIcon,
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
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 22),
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
              const Positioned(
                left: 40,
                top: 420,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageButton_change_picture('Change Profile Picture'),
                    SizedBox(width: 25),
                    ImageButton_change_nickname('Change Nickname'),
                    SizedBox(width: 25),
                    ImageButton('Logout'),
                  ],
                ),
              ),
              Positioned(
                top: 170,
                left: 0,
                child: Image.asset(
                  'assets/profile.png', // Use the map image
                  width: 410,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 202,
                left: 23,
                child: Image.asset(
                  'assets/profile_circle.png', // Use the map image
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 220,
                left: 53,
                child: Image.asset(
                  profileIcon, // Use the map image
                  width: 100,
                  height: 119,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  top: 220,
                  left: 200,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/profile_name.png', // Use the map image
                        width: 188,
                        height: 47,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 12,
                        top: 5,
                        child: Text(
                          nickname,
                          style: const TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                  top: 280,
                  left: 280,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/profile_level.png', // Use the map image
                        width: 103,
                        height: 47,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 15,
                        top: 7,
                        child: Text(
                          'lvl $level',
                          style: const TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ),
                    ],
                  )),
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
              'assets/nav_bar_profile.png',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
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

class ImageButton extends StatelessWidget {
  final String label;
  //final String imagePath;

  const ImageButton(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          logout(context);
        },
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

Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  } catch (e) {
    print('Error logging out: $e');
    // Optionally show an error message to the user
  }
}


Future<void> updateUserNickname(String newNickname, BuildContext context) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      'nickname': newNickname,
    });
    Navigator.of(context).pop();
  }
}

class ImageButton_change_nickname extends StatelessWidget {
  final String label;
  //final String imagePath;

  const ImageButton_change_nickname(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newNickname = '';
              return AlertDialog(
                title: const Text('Change Nickname'),
                content: TextField(
                  onChanged: (value) {
                    newNickname = value;
                  },
                  decoration: const InputDecoration(hintText: "Enter new nickname"),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      if (newNickname.isNotEmpty) {
                        _ProfileState profileState = context.findAncestorStateOfType<_ProfileState>()!;
                        profileState.updateNickname(newNickname); // Update local state
                        updateUserNickname(newNickname, context); // Update Firebase
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
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

class ImageButton_change_picture extends StatelessWidget {
  final String label;
  //final String imagePath;

  const ImageButton_change_picture(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          _ProfileState profileState = context.findAncestorStateOfType<_ProfileState>()!;
          showProfileIconSelection(context, profileState.updateIcon);
        },
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


void showProfileIconSelection(BuildContext context, Function(String) onIconSelected) {
  String tempIconPath = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select Profile Picture"),
        content: SizedBox(
          // Adjust the size as needed
          width: double.maxFinite,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            shrinkWrap: true,
            itemCount: 15, // Assuming you have 16 profile icons
            itemBuilder: (context, index) {
              String iconPath = 'assets/profile_icons/$index.png';
              return GestureDetector(
                onTap: () {
                  tempIconPath = iconPath;
                  // Show a preview or confirmation dialog here if needed
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Profile Picture"),
                        content: Image.asset(tempIconPath, width: 130, height: 130),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close confirmation dialog
                            },
                          ),
                          TextButton(
                            child: const Text("Confirm"),
                            onPressed: () {
                              updateUserProfileIcon(tempIconPath, context);
                              onIconSelected(tempIconPath); // Update the state in Profile widget
                              Navigator.of(context).pop(); // Close confirmation dialog
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Image.asset(iconPath, width: 65, height: 78),
              );
            },
          ),
        ),
      );
    },
  );
}


Future<void> updateUserProfileIcon(String iconPath, BuildContext context) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      'profileIcon': iconPath,
    });
    Navigator.of(context).pop(); // Close the dialog
  }
}
