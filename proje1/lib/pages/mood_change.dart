import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodWidget extends StatefulWidget {
  final String userId;

  const MoodWidget({Key? key, required this.userId}) : super(key: key);
  @override
  _MoodWidgetState createState() => _MoodWidgetState();
}

class _MoodWidgetState extends State<MoodWidget> {
  bool isMoodAvailable = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final collectionReference =
        FirebaseFirestore.instance.collection("Users");
    final profileSnapshot =
        await collectionReference.doc(widget.userId).get();

    setState(() {
      isMoodAvailable = profileSnapshot.data()?['mood'] ?? false;
    });
  }

  void toggleMood() {
    setState(() {
      isMoodAvailable = !isMoodAvailable;
    });

    updateMoodInFirestore(isMoodAvailable);
  }

  void updateMoodInFirestore(bool newMood) {
    final moodRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(firebaseAuth.currentUser?.uid);

    moodRef
        .update({
          'mood': newMood,
        })
        .then((value) => print('Mood güncellendi!'))
        .catchError((error) =>
            print('Mood güncellenirken hata oluştu: $error'));
  }
@override
Widget build(BuildContext context) {
  Color avatarColor = isMoodAvailable ? Colors.green : Colors.red;

  return GestureDetector(
    onTap: toggleMood,
    child: CircleAvatar(
      radius: 6.0,
      backgroundColor: avatarColor,
    ),
  );
}
}

