import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/app/sign_in/email_sign_in_form.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({
    required this.auth,
  });

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Sign In'),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          child: Card(
            child: EmailSignInForm(auth: auth),
          ),
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
