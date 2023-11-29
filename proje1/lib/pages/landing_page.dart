import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proje1/pages/home_page.dart';
import 'package:proje1/pages/log_in_page.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
   UserCredential? user1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }


  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    
    if (user1 == null) {
      return const login_page();
    } else {
     return const HomePage(); 
    }
  }

  Future<void> _checkUser() async {
   // user1 = (await FirebaseAuth.instance.currentUser) as UserCredential?;
  }
}
