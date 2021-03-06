import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/users_messages.dart';
import 'package:flutter_chat/widgets/chat/messages.dart';
import 'package:flutter_chat/widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const namedRoute = '/chatScreen';
  final String userName;
  ChatScreen({this.userName});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg) {
        print('onMessage :$msg');
        return;
      },
      onLaunch: (msg) {
        print('onLaunch :$msg');
        return;
      },
      onResume: (msg) {
        print('onResume :$msg');
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('back button press...');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => UsersMessages(),
          ),
        );
        return Navigator.canPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('flutter chat '),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: MessagesStream(userName: widget.userName)),
            NewMessage(userName: widget.userName),
          ],
        ),
      ),
    );
  }
}
