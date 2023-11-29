import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';

class DeleteTaskPage extends StatefulWidget {
  final String taskId, gorevAd, start;
  

  const DeleteTaskPage({
    Key? key,
    required this.taskId, required this.gorevAd, required this.start,
  }) : super(key: key);

  @override
  DeleteTaskAlertDialogState createState() => DeleteTaskAlertDialogState();
}

class DeleteTaskAlertDialogState extends State<DeleteTaskPage> {
  final TextEditingController gorevAdController = TextEditingController();
  final TextEditingController gorevAciklamaController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
   
  Future<void> _updateTasks(String gorevAd, String gorevAciklama, String taskId) async {
  var userId = firebaseAuth.currentUser?.uid;
  var collectionReference = FirebaseFirestore.instance
      .collection('Tasks')
      .doc(userId)
      .collection("UserTasks");

  try {
    await collectionReference
        .doc(taskId) // taskId'yi kullanın
        .update({
          'Task': gorevAd,
          'Explanation': gorevAciklama,
        })
        .then((_) => Fluttertoast.showToast(
              msg: "Task updated successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14.0,
            ));
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Failed: $error",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Görevi Sil',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 101, 33, 155)),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
              Text('Silmek istediğinden emin misin?', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 15),
              Text(
                widget.gorevAd.toString(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),  
            
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Kapat'),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteTasks();
            deleteDataFromFirebase(widget.start);

            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Sil'),
        ),
      ],
    );
  }

  Future _deleteTasks() async {
      var userId = firebaseAuth.currentUser?.uid;
      var collection = FirebaseFirestore.instance
      .collection('Tasks')
      .doc(userId)
      .collection("UserTasks");    
      
      collection
        .doc(widget.taskId)
        .delete()
        .then(
          (_) => Fluttertoast.showToast(
              msg: "Task deleted successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14.0),
        )
        .catchError(
          (error) => Fluttertoast.showToast(
              msg: "Failed: $error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14.0),
        );
  }

  void deleteDataFromFirebase(String start) {
    final databaseReference = FirebaseDatabase.instance.reference();

    DatabaseReference tasksFolderReference =
        databaseReference.child(firebaseAuth.currentUser!.uid).child(start);
    tasksFolderReference.remove().then((value) {
      print('Veriler başarıyla silindi!');
    }).catchError((error) {
      print('Veri silme hatası: $error');
    });
  }


}
