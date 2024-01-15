import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(background: const Color(0xFFC1B350)),
      ),
    );
  }
}


class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 932,
          width: 430,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset('assets/treasurehunt 1.png', width: 430, height: 401),
                const SizedBox(height: 10), // Adjusted height
                //const ImageWithText('Email', 288, 85),
                //const SizedBox(height: 10),
                ImageButton('Email', textController: emailController),
                const SizedBox(height: 10),// Adjusted height
                //const ImageWithText('Password', 288, 85),
                ImageButton('Password', textController: passwordController),
                const SizedBox(height: 10), // Adjusted height
                const ForgotPasswordButton(),
                const SizedBox(height: 10), // Adjusted height
                LoginButton(
                  emailController: emailController,
                  passwordController: passwordController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15), // Adjust the top margin as needed
                      child: const Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10), // Adjusted width
                    const SignUpButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageWithText extends StatelessWidget {
  final String labelText;
  final double imageWidth;
  final double imageHeight;

  const ImageWithText(this.labelText, this.imageWidth, this.imageHeight, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/wood texture 3.png', width: imageWidth, height: imageHeight),
          Text(labelText, style: const TextStyle(
            color: Colors.white,
            fontSize: 28, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Adjust the font weight as needed
          ),),
        ],
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final TextEditingController textController;
  final String label;

  const ImageButton(this.label, {required this.textController, super.key});

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
          width: 288,
          height: 85,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/wood texture 3.png',
                  width: 288,
                  height: 85,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 288,
                  height: 85,
                  child: TextField(
                    controller: textController,
                    textAlign: TextAlign.center, // Center text horizontally
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Reggae One',
                    ),
                    decoration: InputDecoration(
                      hintText: label,
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 20,
                        fontFamily: 'Reggae One',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 30), // Adjust padding to center text vertically
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle Forgot Password button tap
      },
      child: Container(
        margin: const EdgeInsets.only(left: 219),
        width: 154,
        height: 24,
        child: const Text('Forgot my password', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({super.key, required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Handle Login button tap
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          // If successful, navigate to the Home page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } on FirebaseAuthException {
          // Show a snackbar if login fails
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incorrect email/password, please try again'),
              backgroundColor: Colors.red, // Optional: to enhance visibility
            ),
          );
        }
      },
      child: Stack(
        children: [
          Image.asset(
            'assets/wood texture 6.png',
            width: 160,
            height: 51,
            fit: BoxFit.cover, // Adjust the fit property as needed
          ),
          const Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Log in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28, // Adjust the font size as needed
                  fontWeight: FontWeight.bold, // Adjust the font weight as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSignUpDialog(context);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        width: 130,
        height: 41,
        child: Stack(
          children: [
            Image.asset(
              'assets/wood texture 6.png',
              width: 130,
              height: 41,
              fit: BoxFit.cover, // Adjust the fit property as needed
            ),
            const Center(
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showSignUpDialog(BuildContext context) async {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button to close the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sign Up'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                controller: nicknameController,
                decoration: const InputDecoration(hintText: 'Nickname'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Sign Up'),
            onPressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
                // Here, you can save the nickname to your database if needed
                // User is successfully signed up, now add additional details to Firestore
                await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                  'email': emailController.text,
                  'nickname': nicknameController.text,
                  'diamonds': 20,  // Initial diamonds value
                  'level': 1,      // Initial level value
                  'friendList': [],
                });


                Navigator.of(context).pop(); // Close the dialog
                // You may navigate to the home screen or show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Congratulations! You signed up successfully. You can now log in and start playing.'),
                    backgroundColor: Colors.green,  // Optional: to enhance visibility
                  ),
                );
              } on FirebaseAuthException catch (e) {
                // Handle errors (e.g., email already in use, weak password)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to sign up: ${e.message}'),
                    backgroundColor: Colors.red,  // Optional: to enhance visibility
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
