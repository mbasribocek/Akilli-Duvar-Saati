import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proje1/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:proje1/pages/update_task.dart';

import 'compledet_task.dart';
import 'delete_task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late List<Map<dynamic, dynamic>> tasks = [];

  //final PageController pageController = PageController(initialPage: 0);
  //late int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    //FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final collectionReference = FirebaseFirestore.instance.collection("Tasks");
    final taskSnapshot =
        await collectionReference.doc(userId).collection("UserTasks").get();

    final List<Map<dynamic, dynamic>> taskList = [];
    taskSnapshot.docs.forEach((doc) {
      taskList.add(doc.data());
    });

    taskList.sort((a, b) {
      final int startTimeA = int.parse(a['startime'].split(':')[0]);
      final int startTimeB = int.parse(b['startime'].split(':')[0]);
      return startTimeA.compareTo(startTimeB);
    });

    setState(() {
      tasks = taskList;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final taskId = task['id'];
          final taskAd = task['Task'];
          final taskAciklama = task['Explanation'];
          final starttime = task['startime'];
          final finishtime = task['finishtime'];
          final color = task['color'];
          SizedBox(width: 15.0);

          return Container(
            margin: const EdgeInsets.all(10.0),
            //height: 100,
            //height: calculateTextHeight(taskAd + '\n' + taskAciklama, MediaQuery.of(context).size.width) * 50.0,
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

              title: Text(
                taskAd,
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 101, 33, 155),
                ),
              ),
              /*subtitle: Text('Açıklama:' + '  ' + taskAciklama + '  ' + 'Zaman Aralığı:' + starttime  + '-' + finishtime , style: TextStyle(color: const Color.fromARGB(255, 133, 132, 132)),),*/

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Açıklama:' + '  ' + taskAciklama,
                    style: TextStyle(color: Color.fromARGB(255, 108, 107, 107)),
                  ),
                  Text(' '),
                  Wrap(
                    children: [
                      Icon(
                        Icons.alarm,
                        size: 19.0,
                        color: Color.fromARGB(255, 101, 33, 155),
                      ),
                      Text(' '),
                      Text(' '),
                      Text(starttime + '-' + finishtime,
                          style: TextStyle(fontSize: 17)),
                    ],
                  )
                ],
              ),

              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'edit',
                      child: const Text(
                        'Güncelle',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      onTap: () {
                        String taskId = (task['id']);
                        String gorevAd = (task['Task']);
                        String gorevAciklama = (task['Explanation']);
                        String starttime = (task['startime']);
                        String finishtime = (task['finishtime']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateTaskPage(
                                      taskId: taskId,
                                      gorevAd: gorevAd,
                                      gorevAciklama: gorevAciklama,
                                      starttime: starttime,
                                      finishtime: finishtime,
                                    )));

                        Future.delayed(
                          const Duration(seconds: 0),
                          () => showDialog(
                            context: context,
                            builder: (context) => UpdateTaskPage(
                                taskId: taskId,
                                gorevAd: gorevAd,
                                gorevAciklama: gorevAciklama,
                                starttime: starttime,
                                finishtime: finishtime
                            ,),
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: const Text(
                        'Sil',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      onTap: () {
                        String taskId = (task['id']);
                        String gorevAd = (task['Task']);
                        String start = (task['startime']);
                        Future.delayed(
                          const Duration(seconds: 0),
                          () => showDialog(
                            context: context,
                            builder: (context) => DeleteTaskPage(
                                taskId: taskId, gorevAd: gorevAd, start: start,),
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      value: 'check',
                      child: const Text(
                        'Görevi Sonlandır',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      onTap: () {
                        String taskId = (task['id']);
                        String gorevAd = (task['Task']);
                        String start = (task['startime']);
                        Future.delayed(
                          const Duration(seconds: 0),
                          () => showDialog(
                            context: context,
                            builder: (context) => CompletedTaskPage(
                                taskId: taskId, gorevAd: gorevAd, start: start,),
                          ),
                        );
                      },
                    ),
                  ];
                },
              ),

              //isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
