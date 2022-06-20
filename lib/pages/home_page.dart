// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, avoid_print, unnecessary_null_in_if_null_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uts/google_sign_in_provider.dart';
import 'package:flutter_uts/models/task_model.dart';
import 'package:flutter_uts/models/user_model.dart';
import 'package:flutter_uts/pages/all_tasks_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_uts/pages/profile_page.dart';
import 'package:flutter_uts/pages/tasks_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel userModel = UserModel();
  User? userLoggedIn = FirebaseAuth.instance.currentUser ?? null;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .doc(userLoggedIn!.uid)
        .get()
        .then(
      (value) {
        if (mounted) {
          setState(() {
            userModel = UserModel.fromJson(value.data());
          });
        } else {
          return null;
        }
      },
    );
  }

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

  Widget buildTodayTasks() {
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
            children: tasks.map(buildTodayTask).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildUpcomingTasks() {
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
            children: tasks.map(buildUpcomingTask).toList(),
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
    var dateTime = DateTime.now().toString();
    final re = RegExp(r'T*');
    final dateSplit = task.date.toIso8601String().split(re);
    final dateTimeSplit = dateTime.toString().split(re);

    return '${dateTimeSplit[8]}${dateTimeSplit[9]}-${dateTimeSplit[5]}${dateTimeSplit[6]}-${dateTimeSplit[0]}${dateTimeSplit[1]}${dateTimeSplit[2]}${dateTimeSplit[3]}' ==
            '${dateSplit[8]}${dateSplit[9]}-${dateSplit[5]}${dateSplit[6]}-${dateSplit[0]}${dateSplit[1]}${dateSplit[2]}${dateSplit[3]}'
        ? Column(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          'Task Deleted successfully',
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color(0xffFFC045),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                ),
              ),
              const SizedBox(height: 24),
            ],
          )
        : Container();
  }

  Widget buildTodayTask(TaskModel task) {
    var dateTime = DateTime.now().toString();
    final re = RegExp(r'T*');
    final dateSplit = task.date.toIso8601String().split(re);
    final dateTimeSplit = dateTime.toString().split(re);

    return '${dateTimeSplit[8]}${dateTimeSplit[9]}-${dateTimeSplit[5]}${dateTimeSplit[6]}-${dateTimeSplit[0]}${dateTimeSplit[1]}${dateTimeSplit[2]}${dateTimeSplit[3]}' ==
            '${dateSplit[8]}${dateSplit[9]}-${dateSplit[5]}${dateSplit[6]}-${dateSplit[0]}${dateSplit[1]}${dateSplit[2]}${dateSplit[3]}'
        ? Column(
            children: [
              Container(
                width: double.infinity,
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(200, 255, 192, 69),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
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
              ),
              const SizedBox(height: 24),
            ],
          )
        : Container();
  }

  Widget buildUpcomingTask(TaskModel task) {
    var dateTime = DateTime.now().toString();
    final re = RegExp(r'T*');
    final dateSplit = task.date.toIso8601String().split(re);
    final dateTimeSplit = dateTime.toString().split(re);

    return '${dateTimeSplit[8]}${dateTimeSplit[9]}-${dateTimeSplit[5]}${dateTimeSplit[6]}-${dateTimeSplit[0]}${dateTimeSplit[1]}${dateTimeSplit[2]}${dateTimeSplit[3]}' !=
            '${dateSplit[8]}${dateSplit[9]}-${dateSplit[5]}${dateSplit[6]}-${dateSplit[0]}${dateSplit[1]}${dateSplit[2]}${dateSplit[3]}'
        ? Column(
            children: [
              Container(
                width: double.infinity,
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(200, 255, 192, 69),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
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
              const SizedBox(height: 24),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

    // ! Errornya ada dibaris ini

    // final googleName = provider.googleSignIn.currentUser!.displayName;
    // var nameSplit = googleName!.split(' ');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TasksPage(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: const Color(0xffFFC045),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          // height: 55,
          decoration: const BoxDecoration(
            color: Color(0xffEEEEEE),
          ),
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.access_time,
                  size: 30,
                ),
              ),
            ],
            labelColor: Color(0xffFFC045),
            unselectedLabelColor: Color(0xff3F3F3F),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3,
                color: Color(0xffFFC045),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 48, right: 24, left: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          provider.googleSignIn.currentUser != null
                              ? const Text(
                                  // 'Hello, ${nameSplit[0]}',
                                  'Hello, User',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff3F3F3F),
                                  ),
                                )
                              : Text(
                                  userModel.gender == 'man'
                                      ? 'Hello, Bro'
                                      : 'Hello, Sis',
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff3F3F3F),
                                  ),
                                ),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            ),
                            child: provider.googleSignIn.currentUser != null
                                ? Image.asset(
                                    'assets/images/google.png',
                                    height: 50,
                                  )
                                : Image.asset(
                                    userModel.gender == 'man'
                                        ? 'assets/images/man.png'
                                        : 'assets/images/woman.png',
                                    height: 50,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Current Tasks',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff3F3F3F),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AllTasksPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'View All Tasks',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffFFC045),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          buildTodayTasks(),
                        ],
                      ),
                      const SizedBox(height: 64),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Other Tasks',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff3F3F3F),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AllTasksPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'View All Tasks',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffFFC045),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          buildUpcomingTasks(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 32, right: 24, left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Tasks",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3F3F3F),
                        ),
                      ),
                      const SizedBox(height: 24),
                      buildTasks(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
