import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proje1/pages/home_page.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proje1/pages/create2.dart';
import 'package:proje1/pages/select_color.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  String? get taskId => null;

  @override
  AddTaskAlertDialogState createState() => AddTaskAlertDialogState();
}

class AddTaskAlertDialogState extends State<AddTaskPage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final TextEditingController gorevAdController = TextEditingController();
  final TextEditingController gorevAciklamaController = TextEditingController();

  TextEditingController starttimeController = TextEditingController();
  TextEditingController finishtimeController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  int selectedColor = 0xFFAA2234; // Seçilen rengin başlangıç değeri

  Future<void> _addTasks({
    required String gorevAd,
    required String gorevAciklama,
    required String starttime,
    required String finishtime,
    required int color,
  }) async {
    final userId = firebaseAuth.currentUser?.uid;

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(userId)
        .collection("UserTasks")
        .add(
      {
        'Task': gorevAd,
        'Explanation': gorevAciklama,
        'startime': starttime,
        'finishtime': finishtime,
        'color': color,
      },
    );
    String taskId = docRef.id;
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(userId)
        .collection('UserTasks')
        .doc(taskId)
        .update(
      {'id': taskId},
    );
  }

  @override
  Widget build(BuildContext context) {
   
    final _formkey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 110),
          child: AlertDialog(
            scrollable: true,
            title: const Text(
              'Yeni Görev',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 101, 33, 155)),
            ),
            content: SizedBox(
              height: 500,
              width: 200,
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: gorevAdController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Görev',
                        hintStyle: const TextStyle(fontSize: 14),
                        icon: const Icon(
                          CupertinoIcons.square_list,
                          color: Color.fromARGB(255, 101, 33, 155),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: gorevAciklamaController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Açıklama',
                        hintStyle: const TextStyle(fontSize: 14),
                        icon: const Icon(
                          CupertinoIcons.bubble_left_bubble_right,
                          color: Color.fromARGB(255, 101, 33, 155),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: starttimeController,
                      readOnly: true,
                      onTap: () {
                        _startselectTime(context);
                      },
                      decoration: InputDecoration(
                        labelText: 'Başlama Saati',
                      ),
                    ),
                    TextFormField(
                      controller: finishtimeController,
                      readOnly: true,
                      onTap: () {
                        _finishselectTime(context);
                      },
                      decoration: InputDecoration(
                        labelText: 'Bitiş Saati',
                      ),
                    ),
                    SelectColorPage(
                      selectedColor: selectedColor,
                      onColorChanged: (int color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                 Navigator.pushReplacementNamed(context, "/homePage");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                child: const Text('Kapat'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final gorevAd = gorevAdController.text;
                  final gorevAciklama = gorevAciklamaController.text;
                  final starttime = starttimeController.text;
                  final finishtime = finishtimeController.text;
                  final color = selectedColor;

                  if (gorevAd.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Uyarı'),
                        content: Text('Bir görev belirtiniz.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Tamam'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    writeDataToFirebase(starttime, finishtime, color);

                    await _addTasks(
                      gorevAd: gorevAd,
                      gorevAciklama: gorevAciklama,
                      starttime: starttime,
                      finishtime: finishtime,
                      color: color
                    );

                  
                    Navigator.pushReplacementNamed(context, "/homePage");
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startselectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      TimeOfDay selectedTime = pickedTime;
      int onlyhour = selectedTime.hour;
      starttimeController.text = onlyhour.toString();
    }
  }

  Future<void> _finishselectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      TimeOfDay selectedTime = pickedTime;
      int onlyhour = selectedTime.hour;
      finishtimeController.text = onlyhour.toString();
    }
  }

   void writeDataToFirebase(String start, String finish, int color){
    final databaseReference = FirebaseDatabase.instance.reference();

    DatabaseReference tasksFolderReference =
        databaseReference.child(firebaseAuth.currentUser!.uid).child(start);
    tasksFolderReference.set({
      'start': start,
      'finish': finish,
      'color': color,
    }).then((value) {
      print('Veriler başarıyla yazıldı!');
    }).catchError((error) {
      print('Veri yazma hatası: $error');
    });
  }
}