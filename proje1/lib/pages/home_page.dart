import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proje1/pages/selected_profil.dart';
import 'package:proje1/pages/task_list.dart';

import 'add_friend.dart';
import 'add_task.dart';
import 'delete_friend.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> userFriendsList;
  int _selectedIndex = 0;
  String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchUserFriends();
  }

  Future<void> fetchUserFriends() async {
    // Get the user's friends from the Friends collection

    final friendsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID) // Assuming you have a widget.userId for the logged-in user
        .collection('Friends')
        .get();

    setState(() {
      userFriendsList =
          friendsSnapshot.docs.map((doc) => doc['username'] as String).toList();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/lampPage");
            },
            icon: const Icon(Icons.lightbulb, size: 25),
          ),
          IconButton(
            onPressed: () {
              //Navigator.pushReplacementNamed(context, "/profilPage");
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFriend()));   
            },
            icon: const Icon(Icons.person_add, size: 25),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DeleteFriend()));   
            },
            icon: const Icon(Icons.person_remove, size: 25),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/profilPage");
            },
            icon: const Icon(Icons.account_circle, size: 25),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 101, 33, 155),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddTaskPage();
            },
          );
        },
        backgroundColor: Color.fromARGB(255, 101, 33, 155),
        child: const Icon(Icons.add),
      ),
      /*bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color.fromARGB(255, 101, 33, 155),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.jumpToPage(index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.square_list,
                    color: Color.fromARGB(255, 101, 33, 155)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check,
                    color: Color.fromARGB(255, 101, 33, 155)),
                label: '',
              ),
            ],
          ),
        ),
      ),*/
      body: Column(
        children: [
          topBar(),
          SizedBox(width: 30.0),
          SizedBox(width: 30.0),
          Text(
            'İşte Görev Listen!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 57, 27, 117)),
            textAlign: TextAlign.start,
          ),
          Expanded(child: TaskListPage()),
          SizedBox(width: 30.0),
        ],
      ),
    );
  }

Widget topBar() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('Users').doc(currentUserID).collection('Friends').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Veriler yüklenirken bir hata oluştu: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text('Veriler yükleniyor...');
      }
      return SizedBox(
        height: 100.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String selectedUsername = data['username'];
            String selectedUserId = document.id;

            if (selectedUsername.isNotEmpty) {
              String initial = '';
              if (selectedUsername.isNotEmpty) {
                String firstChar = selectedUsername[0].toUpperCase();
                String secondChar = '';
                if (selectedUsername.length > 1) {
                  secondChar = selectedUsername[1].toLowerCase();
                }
                initial = firstChar + secondChar;
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectProfilePage(
                              userId: selectedUserId,
                              taskId: selectedUserId,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Color.fromARGB(255, 202, 187, 236),
                        child: Text(
                          initial,
                          style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 112, 78, 191),
                          ),
                        ),
                      ),
                    ),
                    Text(selectedUsername),
                  ],
                ),
              );
            } else {
              // Kullanıcı bulunamadı, hata işlemleri yapılabilir
              return SizedBox();
            }
          }).toList(),
        ),
      );
    },
  );
}


}
