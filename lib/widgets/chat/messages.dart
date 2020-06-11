import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/chat/message_bubble.dart';

class MessagesStream extends StatelessWidget {
  final String userName;
  MessagesStream({this.userName});

  Future<Map<String, String>> getUserInfo() async {
    final user = await FirebaseAuth.instance.currentUser();
    print(user.uid);
    final userdata =
        await Firestore.instance.collection('users').document(user.uid).get();
    print(userdata['username']);
    return {
      'userUid': user.uid,
      'userName': userdata['username'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserInfo(),
        builder: (ctx, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          print('future return is : ${authSnapshot.data}');
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              List<DocumentSnapshot> chatDocs = chatSnapshot.data.documents
                  .where(
                    (doc) =>
                        doc['sendTo'] == userName &&
                            doc['userUid'] == authSnapshot.data['userUid'] ||
                        //....
                        doc['sendTo'] == authSnapshot.data['userName'] &&
                            doc['userName'] == userName,
                  )
                  .toList();

              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageBubble(
                    chatDocs[index]['text'],
                    chatDocs[index]['userUid'] == authSnapshot.data['userUid'],
                    chatDocs[index]['userName'],
                    chatDocs[index]['userImage'],
                    key: ValueKey(chatDocs[index].documentID),
                  );
                },
              );
            },
          );
        });
  }
}
