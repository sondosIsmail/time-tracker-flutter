import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/app/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
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
            child: EmailSignInFormChangeNotifier.create(context),
          ),
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
