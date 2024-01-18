import 'package:flutter/material.dart';
import 'home.dart';
import 'settings.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'widgets/leaderboard_friend_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Friends(),
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

class Friends extends StatelessWidget {
  const Friends({super.key});

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
              const Positioned(
                left: 93,
                top: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageButton_Search('Search User', 'assets/Map 1.png'),
                    SizedBox(height: 25),
                    ImageButton_request(
                        'Friend Requests', 'assets/request.png'),
                  ],
                ),
              ),
              Positioned(
                top: 300,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 220, // Adjust height as needed
                  child: const LeaderboardFriendPanel(),
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
              'assets/nav_bar_friends.png',
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
                onTap: () {},
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

class ImageButton_Search extends StatelessWidget {
  final String label;
  final String imagePath;

  const ImageButton_Search(this.label, this.imagePath, {super.key});

  void _promptForEmail(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = '';
        return AlertDialog(
          title: const Text('Enter User Email'),
          content: TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(hintText: "Email"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Send Request'),
              onPressed: () {
                sendFriendRequest(context, email);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () => _promptForEmail(context),
        child: SizedBox(
          width: 258,
          height: 70,
          child: Stack(
            children: [
              Image.asset(
                'assets/wood texture 6.png',
                width: 258,
                height: 70,
                fit: BoxFit.cover,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      imagePath,
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(width: 3),
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

class ImageButton_request extends StatelessWidget {
  final String label;
  final String imagePath;

  const ImageButton_request(this.label, this.imagePath, {super.key});

  void _showFriendRequests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<List<FriendRequest>>(
          stream: getFriendRequests(), // This is the stream of friend requests
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print("Error loading friend requests: ${snapshot.error}");
              return const Center(child: Text("Error loading requests"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No friend requests"));
            }

            List<FriendRequest> requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                FriendRequest request = requests[index];
                return ListTile(
                  title: Text(request.senderName), // Display sender's name
                  subtitle: Text(request.senderEmail), // Display sender's email
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          User? currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            acceptFriendRequest(
                                request.senderId);
                          }
                          // Optionally, remove the request from the list in the UI
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          User? currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            rejectFriendRequest(
                                request.senderId, currentUser.uid);
                          }
                          // Optionally, remove the request from the list in the UI
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 615,
      left: 0,
      child: GestureDetector(
        onTap: () {
          _showFriendRequests(context);
        },
        child: SizedBox(
          width: 200,
          height: 48,
          child: Stack(
            children: [
              Image.asset(
                'assets/wood texture 6.png',
                width: 200,
                height: 48,
                fit: BoxFit.cover,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(width: 0),
                    Image.asset(
                      imagePath,
                      width: 40,
                      height: 40,
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

Future<void> sendFriendRequest(BuildContext context, String email) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;
  try {
    // Check if the target email exists in the Users collection
    DocumentSnapshot senderSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    var senderData = senderSnapshot.data() as Map<String, dynamic>;
    if (senderData == null) return;
    var usersCollection = FirebaseFirestore.instance.collection('users');
    var querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      // User with the email exists, create a friend request
      var friendUserId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection('friendRequests').add({
        'senderId': currentUser.uid,
        'receiverId': friendUserId,
        'senderName': senderData['nickname'] ?? 'Default Nickname',
        'senderEmail': senderData['email'] ?? 'default@email.com',
        // Add any other necessary data like timestamps
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request was successfully sent')),
      );
    } else {
      // Handle the case where the email doesn't exist
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There is no user with this email')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong: $e')),
    );
  }
}

class FriendRequest {
  final String senderId;
  final String senderName;
  final String senderEmail;

  FriendRequest({required this.senderId, required this.senderName, required this.senderEmail});

  factory FriendRequest.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return FriendRequest(
      senderId: snapshot.id,
      senderName: data['senderName'] ?? 'Unknown',
      senderEmail: data['senderEmail'] ?? 'No Email',
    );
  }
}

Stream<List<FriendRequest>> getFriendRequests() {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('friendRequests')
      .where('receiverId', isEqualTo: currentUser.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => FriendRequest.fromSnapshot(doc))
      .toList());
}

/*
Future<void> acceptFriendRequest(String senderId) async {
  // Add each user to the other's friends list
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (senderId.isEmpty || currentUser == null) {
    return;
  }
  String receiverId = currentUser.uid;
    if (currentUser != null) {
    String receiverId = currentUser.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('friends')
        .doc(senderId)
        .set({});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('friends')
        .doc(receiverId)
        .set({});
  }
  // Delete the friend request
  await FirebaseFirestore.instance
      .collection('friendRequests')
      .where('senderId', isEqualTo: senderId)
      .where('receiverId', isEqualTo: receiverId)
      .get()
      .then((snapshot) {
    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  });
}
*/

Future<void> acceptFriendRequest(String senderId) async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final receiverId = currentUser.uid;

      // Add each user to the other's friend list
      await addUserToFriendList(senderId, receiverId);
      await addUserToFriendList(receiverId, senderId);

      // Remove the friend request
      await removeFriendRequest(senderId, receiverId);
    }
  } catch (e) {
    print("Error accepting friend request: $e");
    // Handle error as needed
  }
}

Future<void> addUserToFriendList(String friendRequestId, String friendId) async {
  try {
    // Fetch friend request document from Firestore
    DocumentReference requestDocRef = FirebaseFirestore.instance.collection('friendRequests').doc(friendRequestId);

    // Get current friend request data
    DocumentSnapshot requestSnapshot = await requestDocRef.get();

    if (requestSnapshot.exists) {
      Map<String, dynamic> requestData = requestSnapshot.data() as Map<String, dynamic>;

      // Extract the senderId and receiverId from the friend request
      String senderId = requestData['senderId'];
      String receiverId = requestData['receiverId'];

      // Add the receiver as a friend for the sender
      await addFriendForUser(senderId, receiverId);

      // Add the sender as a friend for the receiver
      await addFriendForUser(receiverId, senderId);

      // Remove the friend request document
      await requestDocRef.delete();
    } else {
      // Handle the case where the friend request document doesn't exist
      print("Error: Friend request document does not exist for requestId: $friendRequestId");
    }
  } catch (e) {
    print("Error adding user to friend list: $e");
    // Handle other errors as needed
  }
}

Future<void> addFriendForUser(String userId, String friendId) async {
  // Fetch user document from Firestore
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  // Get current friend list
  DocumentSnapshot userSnapshot = await userDocRef.get();

  // Check if the 'friendList' field exists in the user document
  if (userSnapshot.exists) {
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

    if (userData.containsKey('friendList')) {
      List<dynamic> currentFriendList = userData['friendList'] ?? [];

      // Add the friend to the list if not already present
      if (!currentFriendList.contains(friendId)) {
        currentFriendList.add(friendId);

        // Update the user document to include the friend in the friendList
        await userDocRef.update({'friendList': currentFriendList});
      }
    } else {
      // If the 'friendList' field doesn't exist, you can handle it here
      print("Error: 'friendList' field does not exist in the user document.");
    }
  } else {
    // Handle the case where the user document doesn't exist
    print("Error: User document does not exist for userId: $userId");
  }
}

Future<void> removeFriendRequest(String senderId, String receiverId) async {
  try {
    // Find and delete the friend request document
    QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('friendRequests')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .get();

    for (QueryDocumentSnapshot doc in requestSnapshot.docs) {
      await doc.reference.delete();
    }
  } catch (e) {
    print("Error removing friend request: $e");
    // Handle error as needed
  }
}

Future<void> rejectFriendRequest(String senderId, String receiverId) async {
  // Delete the friend request
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    String receiverId = currentUser.uid;
    await FirebaseFirestore.instance
        .collection('friendRequests')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}



class Image_Friends extends StatelessWidget {
  final String label;
  final String imagePath;
  final String label2;

  const Image_Friends(this.label, this.imagePath, this.label2, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle button tap
      },
      child: SizedBox( // Using Container for better control over styling and padding
        width: MediaQuery.of(context).size.width, // Adjust the width to the screen size
        height: 105,
        child: Stack(
          children: [
            Image.asset(
              'assets/friends.png',
              width: MediaQuery.of(context).size.width, // Adjust the width to the screen size
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
                  const Spacer(), // Use Spacer to automatically adjust the spacing
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
    );
  }
}

class Friend {
  final String nickname;
  final String profileIcon;
  final String level;

  Friend({required this.nickname, required this.profileIcon, required this.level});
}

Future<List<Friend>> fetchFriends() async {
  List<Friend> friendsList = [];
  // Assuming 'userId' is the ID of the current user
  String userId = 'current_user_id';

  // Reference to the user's document
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  // Fetch the user's friend list
  DocumentSnapshot userSnapshot = await userDocRef.get();
  if (userSnapshot.exists) {
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    List<dynamic> friendIds = userData['friendList'] ?? [];

    for (String friendId in friendIds) {
      // Fetch each friend's data
      DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance.collection('users').doc(friendId).get();
      if (friendSnapshot.exists) {
        Map<String, dynamic> friendData = friendSnapshot.data() as Map<String, dynamic>;
        String nickname = friendData['nickname'] ?? 'no_name';
        String profileIcon = friendData['profileIcon'] ?? 'assets/gee_me_053.png';
        String level = friendData['level'];  // Assuming 'level' field always exists

        friendsList.add(Friend(nickname: nickname, profileIcon: profileIcon, level: level));
      }
    }
  }
  return friendsList;
}

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Friend>>(
      future: fetchFriends(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Friend friend = snapshot.data![index];
              return Column(
                children: [
                  Image_Friends(friend.nickname, friend.profileIcon, friend.level),
                  const SizedBox(height: 25),
                ],
              );
            },
          );
        } else {
          return const Text('No friends found');
        }
      },
    );
  }
}

class FriendsListView extends StatelessWidget {
  const FriendsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Friend>>(
      future: fetchFriends(), // Your function to fetch friends data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Friend friend = snapshot.data![index];
              return Image_Friends(friend.nickname, friend.profileIcon, friend.level);
            },
          );
        } else {
          return const Text('No friends found');
        }
      },
    );
  }
}
