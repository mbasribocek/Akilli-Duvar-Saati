import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proje1/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:proje1/pages/update_task.dart';

import 'compledet_task.dart';
import 'delete_task.dart';


class FriendTaskListPage extends StatefulWidget {
    final String taskId;
    final String userId;

  const FriendTaskListPage({Key? key, required this.taskId, required this.userId}) : super(key: key);

  @override
  _FriendTaskListPageState createState() => _FriendTaskListPageState();

}

class _FriendTaskListPageState extends State<FriendTaskListPage> {
  late List<Map<String, dynamic>> tasks = [];


  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final collectionReference = FirebaseFirestore.instance.collection("Tasks").doc(widget.userId).collection("UserTasks");
    final taskSnapshot = await collectionReference.get();

    setState(() {
      tasks = taskSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });

    tasks.sort((a, b) {
      final int startTimeA = int.parse(a['startime'].split(':')[0]);
      final int startTimeB = int.parse(b['startime'].split(':')[0]);
      return startTimeA.compareTo(startTimeB);
    });
  }

  /* ekleme zamanına göre
  Future<void> fetchTasks() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final collectionReference = FirebaseFirestore.instance.collection("Tasks");
  final taskSnapshot = await collectionReference.doc(userId).collection("Tasks").orderBy('createdAt').get();

  final List<Map<String, dynamic>> taskList = [];
  taskSnapshot.docs.forEach((doc) {
    taskList.add(doc.data());
  });

  setState(() {
    tasks = taskList;
  });
  }*/

  @override
Widget build(BuildContext context) {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  return Scaffold(
    body: ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final taskAd = task['Task'];
        final taskAciklama = task['Explanation'];
        final starttime = task['startime'];
        final finishtime = task['finishtime']; 
        final color = task['color'];

        return Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                offset: Offset(0, 5),
              )
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Color(color),
            ),
            title: Text(taskAd, style: TextStyle(fontSize: 18, color:Color.fromARGB(255, 101, 33, 155),),),
              /*subtitle: Text('Açıklama:' + '  ' + taskAciklama + '  ' + 'Zaman Aralığı:' + starttime  + '-' + finishtime , style: TextStyle(color: const Color.fromARGB(255, 133, 132, 132)),),*/
              
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Açıklama:' + '  ' + taskAciklama,style: TextStyle(color: Color.fromARGB(255, 108, 107, 107)),),
                    Text(' '),
                    Wrap(
                      children: [
                        Icon(Icons.alarm,size: 19.0, color: Color.fromARGB(255, 101, 33, 155),),
                        Text(' '),
                        Text(' '),
                        Text(starttime  + '-' + finishtime, style: TextStyle(fontSize: 17) ),
                      ],
                    )
                  ],
                ),
          ),
        );
      },
    ),
  );
}


}
