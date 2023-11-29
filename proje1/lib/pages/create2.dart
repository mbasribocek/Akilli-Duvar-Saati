import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proje1/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:proje1/pages/add_task.dart';

class create2 extends StatefulWidget {
  const create2({Key? key}) : super(key: key);

  @override
  State<create2> createState() => _createAccountState();
}

class _createAccountState extends State<create2> {
    String username = "";
    String email = "";
    String password1 = "";
    String? birthday = "";
    final formkey1 = GlobalKey<FormState>();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final Firebasefirestore = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Üye Ol"),
        backgroundColor: const Color.fromARGB(255, 101, 33, 155),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
  

        child: SingleChildScrollView(
          child: Form(
                   key: formkey1,
                       child: Column(
                  children: [
              
                    Container(
                        width: 200,
                        height: 200,
                        child: Image.asset('images/clock.png')
                    ), //logo
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bilgileri eksiksiz doldurunuz.";
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
                          return "Bilgileri eksiksiz doldurunuz.";
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
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bilgileri eksiksiz doldurunuz.";
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
              
                    const SizedBox(height: 10),

                     InkWell(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        final formatter = DateFormat('dd-MM-yyyy');
                        birthday = formatter.format(selectedDate);
                      });
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bilgileri eksiksiz doldurunuz.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        birthday = value;
                      },
                      controller: TextEditingController(text: birthday),
                      decoration: InputDecoration(
                        hintText: 'Doğum Tarihi',
                        icon: Icon(CupertinoIcons.calendar),
                        border: OutlineInputBorder(),
                        iconColor: Colors.purple,
                      ),
                    ),
                  ),
                ),
                    
                    const SizedBox(height: 20),

              
                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () async {
                          if (formkey1.currentState!.validate()) {
                            formkey1.currentState!.save();
                            print(email);
                            print(password1);
                            try {
                              var userResult =
                                  await firebaseAuth.createUserWithEmailAndPassword(
                                      email: email, password: password1.toString());
              
                              try {
                                final resultdata = await FirebaseFirestore.instance
                                    .collection("Users").doc(firebaseAuth.currentUser?.uid)
                                    .set({
                                  "email": email,
                                  "username": username,
                                  "userid":firebaseAuth.currentUser?.uid,
                                  "birthday": birthday,
                                     
                                });
                                
                                
                              } catch (e) {
                                print(e);
                              }
                              print(userResult.user!.email);
              
                              print(password1);
                              formkey1.currentState!.reset();
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
                        child: const Text("Kayıt Ol")
                      ),
                    TextButton(
                        style: TextButton.styleFrom(primary: Colors.black45),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("geri dön"))
                  ],
                ),
                    ),
        ),
      ), 
    );
  }
}


