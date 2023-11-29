import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proje1/pages/select_color.dart';

import 'home_page.dart';

class UpdateTaskPage extends StatefulWidget {
  final String taskId, gorevAd, gorevAciklama, starttime, finishtime;
  

  const UpdateTaskPage({
    Key? key,
    required this.taskId, required this.gorevAd, required this.gorevAciklama, required this.starttime, required this.finishtime,
  }) : super(key: key);

  @override
  UpdateTaskAlertDialogState createState() => UpdateTaskAlertDialogState();
}

class UpdateTaskAlertDialogState extends State<UpdateTaskPage> {
  final TextEditingController gorevAdController = TextEditingController();
  final TextEditingController gorevAciklamaController = TextEditingController();
  TextEditingController starttimeController = TextEditingController();
  TextEditingController finishtimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    starttimeController.text = widget.starttime; // Firebase'den çekilen starttime değerini metin alanına atama
    finishtimeController.text = widget.finishtime; // Firebase'den çekilen finishtime değerini metin alanına atama
  }
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  Future<void> _updateTasks(String gorevAd, String gorevAciklama, String taskId, String starttime, String finishtime) async {
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
            'startime': starttime,
            'finishtime': finishtime,
          })
          .then((_) => Fluttertoast.showToast(
                msg: "Task updated successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
              ));
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
    }
  }


  /* @override
  void initState() {
    super.initState();
    //gorevAdController = TextEditingController(text: widget.gorevAd);
    //gorevAciklamaController = TextEditingController(text: widget.gorevAciklama);
  } 

  @override
  void dispose() {
    /* gorevAdController.dispose();
    gorevAciklamaController.dispose(); */
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    gorevAdController.text = widget.gorevAd;
    gorevAciklamaController.text = widget.gorevAciklama;
    
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final _formkey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 210),
          child: AlertDialog(
            scrollable: true,
            title: const Text(
              'Görevini Güncelle',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 101, 33, 155)),
            ),
            content: SizedBox(
              height: height * 0.18,
              width: width,
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: gorevAdController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Görev',
                        icon: const Icon(CupertinoIcons.square_list, color: Color.fromARGB(255, 101, 33, 155)),
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
                        icon: const Icon(CupertinoIcons.bubble_left_bubble_right, color: Color.fromARGB(255, 101, 33, 155)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                          /*TextFormField(
                            controller: starttimeController,
                            readOnly:
                                true, // Metin alanının düzenlenmesini engellemek için readOnly özelliğini true yapın
                            onTap: () {
                              _startselectTime(
                                  context); // Metin alanına tıklandığında saat seçicisini açan metodu çağırın
                            },
                            decoration: InputDecoration(
                              labelText: 'Başlama Saati',
                            ),
                          ),
                          TextFormField(
                            controller: finishtimeController,
                            readOnly:
                                true, // Metin alanının düzenlenmesini engellemek için readOnly özelliğini true yapın
                            onTap: () {
                              _finishselectTime(
                                  context); // Metin alanına tıklandığında saat seçicisini açan metodu çağırın
                            },
                            decoration: InputDecoration(
                              labelText: ' Bitiş Saati',
                            ),
                          ),*/
                                              
                          //SelectColorPage(),
                          
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
                  final gorevAd = gorevAdController.text;
                  final gorevAciklama = gorevAciklamaController.text;
                  final starttime = starttimeController.text;
                  final finishtime = finishtimeController.text;

                  writeStartToFirebase(starttime);
                  writeFinishToFirebase(finishtime );
                  writeColorToFirebase("100,100,100");
                        
                  _updateTasks(gorevAd, gorevAciklama, widget.taskId, starttime, finishtime);
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
                },
                child: const Text('Güncelle'),
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
      // Seçilen saati saklamak için bir değişken kullanabilirsiniz
      TimeOfDay selectedTime = pickedTime;
      int onlyhour = selectedTime.hour;
      // TimeOfDay verisini String'e dönüştürerek TextEditingController'e atayın
      starttimeController.text = onlyhour.toString();
    }
  }

  Future<void> _finishselectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Seçilen saati saklamak için bir değişken kullanabilirsiniz
      TimeOfDay selectedTime = pickedTime;
      int onlyhour = selectedTime.hour;
      // TimeOfDay verisini String'e dönüştürerek TextEditingController'e atayın
      finishtimeController.text = onlyhour.toString();
    }
  }

  void writeStartToFirebase(String number) {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference startFolderReference = databaseReference.child('start');
    startFolderReference.set(number).then((value) {
      print('Sayı başarıyla yazıldı!');
    }).catchError((error) {
      print('Sayı yazma hatası: $error');
    });
  }

  void writeFinishToFirebase(String number) {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference startFolderReference = databaseReference.child('finish');
    startFolderReference.set(number).then((value) {
      print('Sayı başarıyla yazıldı!');
    }).catchError((error) {
      print('Sayı yazma hatası: $error');
    });
  }
  void writeColorToFirebase(String number) {
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference startFolderReference = databaseReference.child('color');
    startFolderReference.set(number).then((value) {
      print('Renk başarıyla yazıldı!');
    }).catchError((error) {
      print('Renk yazma hatası: $error');
    });
  }


}