import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  String _selectedUsername = "";
  List<bool> _isFriendList = [];

  List<String> _currentFriends = [];

  @override
  void initState() {
    super.initState();
    _getCurrentFriends();
  }

  Future<void> _getCurrentFriends() async {
  String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';
  QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserID)
      .collection('Friends')
      .get();

  List<String> friendsList =
      friendsSnapshot.docs.map<String>((doc) => doc['username'] as String).toList();

  setState(() {
    _currentFriends = friendsList;
  });
}


  Future<void> _searchUsers() async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .get();

      setState(() {
        _searchResults = snapshot.docs
            .map((doc) => {'username': doc['username'], 'userid': doc['userid']})
            .toList();
        _isFriendList = List.filled(_searchResults.length, false);
      });

      if (_searchResults.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Böyle bir kullanıcı bulunamadı.'),
          ),
        );
      }
    } else {
      setState(() {
        _searchResults = [];
        _isFriendList = [];
      });
    }
  }

Future<void> _addFriend(int index) async {
  if (_selectedUsername.isNotEmpty) {
    String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';

    DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: _selectedUsername)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);

    if (friendSnapshot.exists) {
      String friendUserID = friendSnapshot.id;

      DocumentSnapshot friendExistsSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserID)
          .collection('Friends')
          .doc(friendUserID)
          .get();

      if (friendExistsSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bu kullanıcı zaten arkadaşınız.'),
          ),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserID)
            .collection('Friends')
            .doc(friendUserID)
            .set({
          'username': _selectedUsername,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Arkadaşınız eklendi.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Böyle bir kullanıcı bulunamadı.'),
        ),
      );
    }

    setState(() {
      _searchResults = [];
      _isFriendList = [];
      _selectedUsername = '';
    });

    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arkadaş Ekle"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/homePage");
            },
            icon: const Icon(Icons.home, size: 25),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 101, 33, 155),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Kullanıcı Adı İle Ara',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchUsers,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text("Kullanıcı adı ile arattığınız kullanıcılar burada görülecektir."),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  bool isFriend = _isFriendList[index];
                  String username = _searchResults[index]['username'];

                  bool isCurrentFriend = _currentFriends.contains(username);

                  if (isCurrentFriend) {
                    return ListTile(
                      title: Text(username),
                      trailing: Text('Arkadaşın', style: TextStyle(color: Colors.grey),),
                      onTap: () {
                        setState(() {
                          _selectedUsername = username;
                        });
                      },
                    );
                  } else {
                    return ListTile(
                      title: Text(username),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedUsername = username;
                            _isFriendList[index] = true;
                          });
                          _addFriend(index);
                        },
                        child: Text('Arkadaş Ekle'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 101, 33, 155),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(10.0),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedUsername = username;
                        });
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
