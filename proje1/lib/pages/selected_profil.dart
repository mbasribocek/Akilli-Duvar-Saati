import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proje1/pages/add_task.dart';
import 'package:proje1/pages/task_list.dart';

import 'delete_friend.dart';
import 'friend_add_task.dart';
import 'friend_task_list.dart';
import 'mood_change.dart';

class SelectProfilePage extends StatefulWidget {
  final String userId;
  final String taskId;


  const SelectProfilePage({Key? key, required this.userId, required this.taskId}) : super(key: key);

  @override
  _SelectProfilePageState createState() => _SelectProfilePageState();
}

class _SelectProfilePageState extends State<SelectProfilePage> {
  late Map<String, dynamic> userProfile = {};
    late List<Map<String, dynamic>> tasks = [];
    


  
  @override
  void initState() {
    super.initState();
    fetchProfile();
    fetchTasks();
  }

  Future<void> fetchProfile() async {
    final collectionReference = FirebaseFirestore.instance.collection("Users");
    final profileSnapshot = await collectionReference.doc(widget.userId).get();

    if (profileSnapshot.exists) {
      setState(() {
        userProfile = profileSnapshot.data() as Map<String, dynamic>;
      });
    }
  }

  Future<void> fetchTasks() async {
    final collectionReference = FirebaseFirestore.instance.collection("Tasks").doc(widget.userId).collection("UserTasks");
    final taskSnapshot = await collectionReference.get();

    setState(() {
      tasks = taskSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


     FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final Firebasefirestore = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Görüntülediğin profil!',
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
              Navigator.pushReplacementNamed(context, "/profilPage");
            },
            icon: const Icon(Icons.account_circle, size: 25),
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
                onTap: () {
                },
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
                    //MoodWidget(userId: FirebaseFirestore.instance.collection("Users").id), //burada da seçilen kullanının id'sini almamız gerekir
                    
                    /*CircleAvatar(
                      radius: 6.0,
                      child: MoodWidget(userId: widget.userId),
                    ),*/

                    CircleAvatar(
                      backgroundColor: _getMoodColor(userProfile['mood']),
                      radius: 6.0,
                    ),

                   
                    Text(' '),

                    Text(' '),
                    Text(
                        '${userProfile['username']}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 88, 88, 90),
                        ), textAlign: TextAlign.center,
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
                      Icons.cake, size: 20, color: Color.fromARGB(255, 165, 135, 236),
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
              
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('24 Saatlik Planı', style: TextStyle(color: const Color.fromARGB(255, 101, 33, 155), fontSize: 25),),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Arka plan rengini şeffaf yapar
                        onSurface: Colors.transparent, // Üstüne gelindiğindeki arka plan rengini şeffaf yapar
                        elevation: 0, // Yükseltilmeyi kaldırır
                      ),
                      /*onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const FriendAddTaskPage(userId: widget.userId,);
                          },
                        );
                      },*/
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FriendAddTaskPage(userId: widget.userId);
                          },
                        );
                      },

                      child: Icon(
                        Icons.note_add_outlined,
                        size: 28,
                        color: Color.fromARGB(255, 101, 33, 155),
                      ),
                    ),

                    
                  ],                
              ),
              ),
              

              Container(
                height: 500, 
                //height: height,
                child: FriendTaskListPage(taskId: widget.taskId, userId: widget.userId,),
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

  Color _getMoodColor(dynamic mood) {
    if (mood == null || mood == false) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}

