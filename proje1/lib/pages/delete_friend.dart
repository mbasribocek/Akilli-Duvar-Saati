import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteFriend extends StatefulWidget {
  const DeleteFriend({Key? key}) : super(key: key);

  @override
  _DeleteFriendState createState() => _DeleteFriendState();
}

class _DeleteFriendState extends State<DeleteFriend> {
  String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<Map<String, dynamic>> _friendsList = [];

  @override
  void initState() {
    super.initState();
    fetchUserFriends();
  }

  Future<void> fetchUserFriends() async {
    final friendsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID)
        .collection('Friends')
        .get();

    setState(() {
      _friendsList = friendsSnapshot.docs
          .map((doc) => {'username': doc['username'], 'friendId': doc.id})
          .toList();
    });
  }

  Future<void> deleteFriend(String friendId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID)
        .collection('Friends')
        .doc(friendId)
        .delete();

    setState(() {
      _friendsList.removeWhere((friend) => friend['friendId'] == friendId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arkadaşını Çıkar"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/homePage");
            },
            icon: const Icon(Icons.home, size: 25),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 101, 33, 155),
      ),
      body: ListView.builder(
        itemCount: _friendsList.length,
        itemBuilder: (BuildContext context, int index) {
          final friend = _friendsList[index];
          return ListTile(
            title: Text(friend['username']),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      //title: const Text('Arkadaşını Çıkar'),
                      content: const Text('Arkadaşını çıkarmak istediğinden emin misin?'),
                      actions: [
                        TextButton(
                          child: const Text('Kapat'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Çıkar'),
                          onPressed: () {
                            deleteFriend(friend['friendId']);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
