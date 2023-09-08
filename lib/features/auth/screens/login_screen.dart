import 'package:flutter/material.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/core/constants/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Image(
            image: AssetImage(Constants.logoPath),
            height: 40,
          ),
        ),
        actions: [TextButton(onPressed: () {}, child: const Text('Skip'))],
      ),
      body: const Column(
        children: [
          SizedBox(height: 20),
          Text(
            'DIVE INTO ANYTHING',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Center(
            child: Image(
              image: AssetImage(Constants.loginEmotePath),
              height: 350,
            ),
          ),
          SizedBox(height: 20),
          SignInButton(),
        ],
      ),
    );
  }
}
