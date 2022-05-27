// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_uts/models/task_model.dart';
import 'package:flutter_uts/pages/tasks_page.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({Key? key}) : super(key: key);

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  User? userLoggedIn = FirebaseAuth.instance.currentUser!;

  Stream<List<TaskModel>> readTasks() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userLoggedIn!.uid)
        .collection('tasks')
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TaskModel.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Widget buildTasks() {
    return StreamBuilder<List<TaskModel>>(
      stream: readTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final tasks = snapshot.data!;
          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: tasks.map(buildTask).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildTask(TaskModel task) {
    final re = RegExp(r'T*');
    final dateSplit = task.date.toIso8601String().split(re);

    return Column(
      children: [
        Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TasksPage(task: task),
                    ),
                  );
                },
                foregroundColor: Colors.grey,
                backgroundColor: const Color.fromARGB(0, 0, 0, 255),
                icon: Icons.edit,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Delete Task',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff3F3F3F),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      content: const Text(
                        'Are you sure?',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3F3F3F),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 60,
                                height: 50,
                                margin: const EdgeInsets.only(
                                  bottom: 20,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xffFFC045),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'No',
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff3F3F3F),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userLoggedIn!.uid)
                                    .collection('tasks')
                                    .doc(task.id)
                                    .delete();

                                const snackBar = SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Deleted from Firebase!',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 60,
                                  height: 50,
                                  margin: const EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xffFFC045),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff3F3F3F),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                foregroundColor: Colors.grey,
                backgroundColor: const Color.fromARGB(0, 0, 0, 255),
                icon: Icons.delete,
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(200, 255, 192, 69),
            ),
            child: Row(
              children: [
                Image.asset(
                  task.image == ''
                      ? 'assets/icons/png/activities.png'
                      : task.image,
                  height: 35,
                ),
                const SizedBox(width: 20),
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${dateSplit[8]}${dateSplit[9]}-${dateSplit[5]}${dateSplit[6]}-${dateSplit[0]}${dateSplit[1]}${dateSplit[2]}${dateSplit[3]}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.time == '' ? '00:00' : task.time,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              top: 32,
              right: 24,
              left: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Color(0xff3F3F3F),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "All Tasks",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff3F3F3F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                buildTasks(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
