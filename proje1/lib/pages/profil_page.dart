import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proje1/pages/task_list.dart';

import 'log_in_page.dart';
import 'mood_change.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> userProfile = {};

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final collectionReference = FirebaseFirestore.instance.collection("Users");
    final profileSnapshot = await collectionReference.doc(widget.userId).get();

    setState(() {
      userProfile = profileSnapshot.data() as Map<String, dynamic>;
    });
  }

  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final Firebasefirestore = FirebaseAuth.instance;

    String mood = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profilin!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        backgroundColor: const Color.fromARGB(255, 101, 33, 155),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/homePage");
            },
            icon: const Icon(Icons.home, size: 25),
          ),
          IconButton(
            onPressed: () {
              signOutUser();
              Navigator.pushReplacementNamed(context, "/loginPage");
            },
            icon: const Icon(Icons.logout_rounded, size: 25),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    //backgroundImage: NetworkImage(userProfile['profilResmi']),
                    radius: 80.0,
                    backgroundColor: Color.fromARGB(255, 215, 215, 237),
                    child: Text(
                      '${userProfile['username'] != null ? _getInitials(userProfile['username']) : ''}',
                      style: const TextStyle(
                        fontSize: 65,
                        color: Color.fromARGB(255, 112, 78, 191),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                width: width,
                height: height * 0.03,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: CircleAvatar(
                        child: MoodWidget(
                          userId: firebaseAuth.currentUser!.uid,
                        ),
                        radius: 6.0,
                      ),
                    ),
                    Text(' '),
                    Text(' '),
                    Text(
                      '${userProfile['username']}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 88, 88, 90),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height * 0.01,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.cake,
                      size: 20,
                      color: Color.fromARGB(255, 165, 135, 236),
                    ),
                    Text(' '),
                    Text(
                      '${userProfile['birthday']}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 88, 88, 90),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height * 0.05,
              ),
              Text(
                'Görevlerim',
                style: TextStyle(
                    color: const Color.fromARGB(255, 101, 33, 155),
                    fontSize: 25),
              ),
              Container(
                height: 500,
                child: TaskListPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

 String _getInitials(String username) {
    if (username.isEmpty) return '';

    String firstChar = username[0].toUpperCase();
    String secondChar = username.length > 1 ? username[1].toLowerCase() : '';

    return firstChar + secondChar;
  }
}
