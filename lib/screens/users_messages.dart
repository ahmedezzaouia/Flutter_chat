import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/modal/user.dart';
import 'package:flutter_chat/provider/delivered_message.dart';
import 'package:flutter_chat/screens/auth_screen.dart';
import 'package:flutter_chat/widgets/user_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UsersMessages extends StatefulWidget {
  @override
  _UsersMessagesState createState() => _UsersMessagesState();
}

class _UsersMessagesState extends State<UsersMessages> {
  String userName = '';
  QuerySnapshot usersDocs;

  Future lastMessage() async {
    print('start ...');

    usersDocs = await Firestore.instance.collection('chat').getDocuments();
    final user = await FirebaseAuth.instance.currentUser();
    final realUser =
        await Firestore.instance.collection('users').document(user.uid).get();
    userName = realUser.data['username'];
    print('the userName : $userName');

    print('finish ...');
  }

  String formatdate(String date) {
    if (date == null || date == '') {
      return '';
    }
    var datepars = DateTime.parse(date);
    var formatter = new DateFormat().add_jms();
    String formattedDate = formatter.format(datepars);
    print('date :$formattedDate'); // 2016-01-25
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my users'),
      ),
      body: FutureBuilder(
        future: lastMessage(),
        builder: (ctx, sendSnap) {
          if (sendSnap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<User> users = [];

              snapShot.data.documents.forEach(
                (doc) {
                  if (doc['username'] == userName) {
                    return;
                  } else {
                    final user = User(
                      imageUrl: doc['userImage'],
                      name: doc['username'],
                    );

                    users.add(user);
                  }
                },
              );

              return Consumer<DeliveredMessage>(
                builder: (ctx, delivered, child) => ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data = delivered.getUserData(
                        anotherUser: users[index].name,
                        usersDocs: usersDocs,
                        userName: userName);
                    print('check data : $data');
                    print('textmesssage :${data['text']}');
                    print('created at :${data['createdAt']}');
                    String message;
                    if (data['text'] == null) {
                      message = '';
                    } else {
                      message = data['text'];
                    }
                    return UserItem(
                      user: users[index],
                      text: message,
                      time: formatdate(data['createdAt']),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
