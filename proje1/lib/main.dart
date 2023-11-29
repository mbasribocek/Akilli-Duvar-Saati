import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proje1/pages/add_friend.dart';
import 'package:proje1/pages/add_task.dart';
import 'package:proje1/pages/home_page.dart';
import 'package:proje1/pages/lamp.dart';
import 'package:proje1/pages/landing_page.dart';
import 'package:proje1/pages/log_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proje1/pages/task_list.dart';
import 'package:proje1/pages/update_task.dart';
import 'firebase_options.dart';
import 'package:proje1/pages/profil_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "proje1",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final Firebasefirestore = FirebaseAuth.instance;
     final TextEditingController gorevAdController = TextEditingController();
  final TextEditingController gorevAciklamaController = TextEditingController();
var userId = firebaseAuth.currentUser?.uid;
    var collection = FirebaseFirestore.instance.collection('Tasks').doc(userId).collection('UserTasks');

  
    Color themecolor = Color.fromARGB(255,101,33,155);
    return MaterialApp(
    
      routes: {
        "/loginPage" : (context) => login_page(),
        "/homePage" : (context) => HomePage(),
         //"/profilPage" : (context) => profilePage(userID: "",), //burda user id göndermemiz gerekiyor.
         "/profilPage" : (context) => ProfilePage(userId: firebaseAuth.currentUser!.uid,),
         "/AddTaskPage" : (context) => AddTaskPage(),
          "/TaskListPage" : (context) => TaskListPage(),
          "/addFriendPage" : (context) => AddFriend(),
          "/lampPage" : (context) => lampPage(),
          //"/addFriendPage" : (context) => AddFriendPage(userId: firebaseAuth.currentUser!.uid,),
          //"/UpdateTaskPage" : (context) => UpdateTaskPage(taskId: taskId, gorevAd: gorevAd, gorevAciklama: gorevAciklama, ), //gorevAd: '', gorevAciklama: '', taskId: '',

      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Akıllı Duvar Saati"),
          backgroundColor: themecolor,
          surfaceTintColor: Colors.amber,
          
        ),
        resizeToAvoidBottomInset: false,
        body: const LandingPage(),
      ),
    );
  }
}
