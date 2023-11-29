import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proje1/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class createAccount extends StatefulWidget {
  const createAccount({Key? key}) : super(key: key);

  @override
  State<createAccount> createState() => _createAccountState();
}

class _createAccountState extends State<createAccount> {


  
  @override
  Widget build(BuildContext context) {
    String username = "";
    String email = "";
    String password1 = "";

    final formkey2 = GlobalKey<FormState>();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final Firebasefirestore = FirebaseAuth.instance;

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceHeight = mediaQueryData.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("üye ol"),
        backgroundColor: const Color.fromARGB(255, 123, 50, 190),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formkey2,
            child: Column(
              children: [
                SizedBox(height: deviceHeight / 20),
                Container(
                    width: 200,
                    height: 200,
                    child: Image.asset('images/clock.png')), //logo
                const SizedBox(
                  height: 20,
                ),






                
                /*TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                  },
                  onSaved: (value) {
                    id = value!;
                  },
                  decoration: const InputDecoration(
                      hintText: "Kullanıcı Adı",
                      icon: Icon(Icons.people),
                      border: OutlineInputBorder(),
                      iconColor: Colors.purple),
                ),*/
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                  decoration: const InputDecoration(
                      hintText: "Kullanıcı Adı",
                      icon: Icon(Icons.people),
                      border: OutlineInputBorder(),
                      iconColor: Colors.purple),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                  decoration: const InputDecoration(
                      hintText: "E-mail",
                      icon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      iconColor: Colors.purple),
                ),

                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                  },
                  onSaved: (value) {
                    password1 = value!;
                  },
                  decoration: const InputDecoration(
                      hintText: "Şifre",
                      icon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                      iconColor: Colors.purple),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                    onPressed: () async {
                      if (formkey2.currentState!.validate()) {
                        formkey2.currentState!.save();
                        print(email);
                        print(password1);
                        try {
                          var userResult =
                              await firebaseAuth.createUserWithEmailAndPassword(
                                  email: email, password: password1.toString());

                          try {
                            final resultdata = await FirebaseFirestore.instance
                                .collection("Users")
                                .add({
                              "email": email,
                              "username": username,
                            });
                          } catch (e) {
                            print(e);
                          }
                          print(userResult.user!.email);

                          print(password1);
                          formkey2.currentState!.reset();
                          Navigator.pushReplacementNamed(context, "/homePage");
                          print(userResult.user!.uid);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Üye oluşturuldu. \nGiriş yapabilirsiniz.")));
                        } catch (e) {
                          print(e.toString());
                        }
                      }
                    },
                    child: const Text("Kayıt Ol")),
                /*TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("geri dön"))*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
