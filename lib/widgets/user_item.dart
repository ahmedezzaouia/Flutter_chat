import 'package:flutter/material.dart';
import 'package:flutter_chat/modal/user.dart';
import 'package:flutter_chat/screens/chat_screen.dart';

class UserItem extends StatelessWidget {
  final User user;
  final String text;
  final String time;
  UserItem({this.user, this.text, this.time});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(userName: user.name),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(6.0),
        elevation: 4.0,
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                time,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
