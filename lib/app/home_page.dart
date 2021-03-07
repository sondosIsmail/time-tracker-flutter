import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.auth,
    required this.onSignOut,
  });

  final AuthBase auth;
  final VoidCallback onSignOut;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: TextButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              onPressed: _signOut,
            ),
          ),
        ],
        elevation: 2.0,
        title: Text('Home Page'),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Container();
  }
}
