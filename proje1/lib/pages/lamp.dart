import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class lampPage extends StatefulWidget {
  const lampPage({Key? key}) : super(key: key);

  @override
  State<lampPage> createState() => _lampPageState();
}

class _lampPageState extends State<lampPage> {
  double currentSliderValue = 150;
  final databaseReference = FirebaseDatabase.instance.reference();

 
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Işık Modu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
           actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/homePage");
            },
            icon: const Icon(Icons.home, size: 25),
          ),
          
        ],
          backgroundColor: const Color.fromARGB(255, 101, 33, 155),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(width: width*0.2,child: Text("  Parlaklık")),
                Container(
                  width: width*0.8,
                  child: Slider(
                    value: currentSliderValue,
                    max: 255,
                    divisions: 20,
                    label: currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        currentSliderValue = value;
                        sendDataToFirebase(currentSliderValue.toString());
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buton("Kırmızı"),
                buton("Mavi"),
                buton("Mor"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                buton("Turuncu"),
                buton("Yeşil"),
                buton("Beyaz")
              ],
            ),
            ElevatedButton(onPressed: (){
               sendLampToFirebase("clock");
            }, child: Text("Saat Modu"))
          ],
        ));
  }

  SizedBox buton(String isim) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
                    onPressed: () {
                      sendLampToFirebase(isim);
                    }, style: ElevatedButton.styleFrom( 
                       shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30.0)
        ),
        primary: Colors.purple.shade800
    ),
                    child: Text(isim)),
    );
  }

  void sendDataToFirebase(String value) {
    databaseReference.child('parlaklik').set(value).then((_) {
      print('Değer Firebase Realtime Database\'e gönderildi!');
    }).catchError((error) {
      print('Hata: $error');
    });
  }

  void sendLampToFirebase(String value) {
    databaseReference.child('lamp').set(value).then((_) {
      print('Değer Firebase Realtime Database\'e gönderildi!');
    }).catchError((error) {
      print('Hata: $error');
    });
  }
}
