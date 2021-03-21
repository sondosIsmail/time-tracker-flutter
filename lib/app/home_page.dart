import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.auth,
  });

  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
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
            padding: const EdgeInsets.only(right: 20.0),
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
