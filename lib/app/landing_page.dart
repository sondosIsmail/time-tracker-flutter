import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:time_tracker_flutter/app/home_page.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter/services/auth_provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);

    return StreamBuilder<User?>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return HomePage();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      stream: auth.authStateChanges,
    );
  }
}
