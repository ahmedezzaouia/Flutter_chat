import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DeliveredMessage with ChangeNotifier {
  Map<String, dynamic> getUserData(
      {String anotherUser, QuerySnapshot usersDocs, String userName}) {
    List<DocumentSnapshot> loadingUsers = [];
    print('length : ${usersDocs.documents.length}');

    if (usersDocs.documents.length == 0 || usersDocs.documents == null) {
      notifyListeners();
      return {};
    } else {
      loadingUsers = usersDocs.documents
          .where(
            (doc) =>
                doc['sendTo'] == userName && doc['userName'] == anotherUser ||
                //send to another
                doc['sendTo'] == anotherUser && doc['userName'] == userName,
          )
          .toList();
      notifyListeners();
      loadingUsers.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
    }
    notifyListeners();

    return loadingUsers.length == 0 ? {} : loadingUsers.first.data;
  }
}
