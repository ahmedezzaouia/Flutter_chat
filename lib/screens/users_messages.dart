import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/modal/user.dart';
import 'package:flutter_chat/widgets/user_item.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersMessages extends StatefulWidget {
  @override
  _UsersMessagesState createState() => _UsersMessagesState();
}

class _UsersMessagesState extends State<UsersMessages> {
  QuerySnapshot usersDocs;
  Future lastMessage() async {
    print('start ...');
    usersDocs = await Firestore.instance.collection('chat').getDocuments();
  }

  getUserData({String anotherUser, String myName}) {
    List<DocumentSnapshot> loadingUsers = [];
    if (usersDocs.documents.length == 0 || usersDocs.documents == null) {
      return [];
    } else {
      try {
        loadingUsers = usersDocs.documents
            .where(
              (doc) =>
                  doc['sendTo'] == myName && doc['userName'] == anotherUser ||
                  //send to another
                  doc['sendTo'] == anotherUser && doc['userName'] == myName,
            )
            .toList();
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        // //check if the key is exist
        // if (prefs.containsKey('myName_anotherUser')) {
        //   print('yes this key is already exist');
        // } else {
        //   prefs.setInt('myName_anotherUser', loadingUsers.length);
        //   print('stor the value with key :${'anotherUser_myName'}');
        // }

        loadingUsers.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
      } catch (error) {
        print(error.toString());
      }
    }

    return loadingUsers.length == 0 ? '' : loadingUsers.first.data;
  }

  String formatdate(String date) {
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
        title: Text('My Users'),
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
                  if (doc['username'] == 'hassan') {
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

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> data = getUserData(
                      anotherUser: users[index].name, myName: 'hassan');
                  print('check data : $data');
                  return UserItem(
                      user: users[index],
                      text: data['text'],
                      time: formatdate(data['createdAt']));
                },
              );
            },
          );
        },
      ),
    );
  }
}
