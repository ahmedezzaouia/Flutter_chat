import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/users_messages.dart';

import 'auth_screen.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my users'),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[Icon(Icons.exit_to_app), Text('LogOut')],
                  ),
                ),
                value: 'LogOut',
              )
            ],
            onChanged: (itemIdentifier) async {
              if (itemIdentifier == 'LogOut') {
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (error) {
                  print('error from sing out : ${error.toString()}');
                }
              }
            },
          )
        ],
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => UsersMessages(),
              ),
            );
          },
          child: Text('go to screen'),
        ),
      ),
    );
  }
}
