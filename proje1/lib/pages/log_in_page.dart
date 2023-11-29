import 'package:flutter/material.dart';
import 'package:proje1/pages/create2.dart';
import 'create_account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login_page extends StatefulWidget {
  const login_page({
    super.key,
  });

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  String id = "";
  String email = "";
  String password2 = "";

  final formkey1 = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

@override
Widget build(BuildContext context) {
  final MediaQueryData mediaQueryData = MediaQuery.of(context);
  final double deviceHeight = mediaQueryData.size.height;
  return Material( // Material widget ekledik
    child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: deviceHeight / 20),
            Form(
              key: formkey1,
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Image.asset('images/clock.png'),
                  ),
                  Text(
                    "Hoşgeldiniz",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
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
                      border: UnderlineInputBorder(),
                      iconColor: Colors.purple,
                    ),
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
                      print("şifre kaydedildi");
                      password2 = value!;
                    },
                    decoration: const InputDecoration(
                      hintText: "Şifre",
                      icon: Icon(Icons.password),
                      border: UnderlineInputBorder(),
                      iconColor: Colors.purple,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(primary: Colors.black45),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => create2()),
                          );
                        },
                        child: Text("Hesap oluştur"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () async {
                      if (formkey1.currentState!.validate()) {
                        formkey1.currentState!.save();
                        print("giriş işlemi başlatıldı");
                        print("mail:" + email);
                        print(password2);
                        try {
                          var userResult =
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email,
                            password: password2,
                          );
                          print("giriş yapıldı");
                          Navigator.pushReplacementNamed(context, "/homePage");
                        } on FirebaseAuthException catch (e) {
                          String errorMessage = "";

                          if (e.code == 'wrong-password' ||
                              e.code == 'user-not-found') {
                            errorMessage =
                                "Şifrenizi ya da mail adresinizi yanlış girdiniz.";
                          } else {
                            errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                            ),
                          );
                        } catch (e) {
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Bir hata oluştu. Lütfen tekrar deneyin."),
                            ),
                          );
                        }
                      }
                    },
                    child: Text("Giriş Yap"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


}
