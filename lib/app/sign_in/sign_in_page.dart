import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:time_tracker_flutter/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter/app/sign_in/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  Future<void> _signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print('${userCredential.user?.uid}');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Time Tracker'),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Container(
      child: Column(
        children: [
          Text(
            'Sign in',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50.0,
          ),
          SocialSignInButton(
            assetName: 'images/google_logo.png',
            color: Colors.white,
            text: 'Sign in with Google',
            textColor: Colors.black,
            onPressed: () {},
          ),
          SizedBox(
            height: 10.0,
          ),
          SocialSignInButton(
            assetName: 'images/facebook_logo.png',
            color: Color(0xFF334D92),
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            onPressed: () {},
          ),
          SizedBox(
            height: 10.0,
          ),
          SignInButton(
            color: Colors.teal[700],
            text: 'Sign in with Email',
            textColor: Colors.white,
            onPressed: () {},
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'or',
            style: TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.0,
          ),
          SignInButton(
            color: Colors.lime[400],
            text: 'Go anonymous',
            textColor: Colors.black,
            onPressed: _signInAnonymously,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      padding: EdgeInsets.all(16.0),
    );
  }
}
