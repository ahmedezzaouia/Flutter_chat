import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/users_messages.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => UsersMessages(),
              ),
            );
          },
          child: Text('go to messanger'),
        ),
      ),
    );
  }
}
