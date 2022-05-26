// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uts/google_sign_in_provider.dart';
import 'package:flutter_uts/models/task_model.dart';
import 'package:flutter_uts/models/user_model.dart';
import 'package:flutter_uts/pages/all_tasks_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_uts/pages/profile_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final TaskModel? task;

  const HomePage({Key? key, this.task}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimeOfDay? time;
  var dropdownValue = 'assets/icons/png/alarm-clock.png';
  bool status = false;
  UserModel userModel = UserModel();
  User? userLoggedIn = FirebaseAuth.instance.currentUser!;
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();

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

    if (widget.task != null) {
      final task = widget.task!;

      titleController.text = task.title;
      descriptionController.text = task.description;
      dateController.text = DateFormat('dd/MM/yyyy').format(task.date);
    }
  }

  String getText() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  Future pickTime(BuildContext context) async {
    const initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime == null) {
      return;
    }

    setState(() {
      time = newTime;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();

    super.dispose();
  }

  Future createTask(TaskModel task) async {
    final docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(userLoggedIn!.uid)
        .collection('tasks')
        .doc();
    task.id = docTask.id;

    final json = task.toJson();
    await docTask.set(json);
  }

  Future updateTask(TaskModel task) async {
    final docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(userLoggedIn!.uid)
        .collection('tasks')
        .doc(task.id);

    final json = task.toJson();
    await docTask.update(json);
  }

  Stream<List<TaskModel>> readTasks() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userLoggedIn!.uid)
        .collection('tasks')
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
    final isEditing = widget.task != null;

    return GestureDetector(
      onTap: () {
        modalBottomSheet(isEditing);
      },
      child: Column(
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
                const Text(
                  '01:00 PM',
                  style: TextStyle(
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
      ),
    );
  }

  Future modalBottomSheet(bool isEditing) {
    return showModalBottomSheet<void>(
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.65,
        ),
      ),
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffEEEEEE),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              iconSize: 0,
                              value: dropdownValue,
                              borderRadius: BorderRadius.circular(20),
                              dropdownColor: const Color(0xffEEEEEE),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });

                                var valueImage = '';
                                if (dropdownValue ==
                                    'assets/icons/png/alarm-clock.png') {
                                  valueImage =
                                      'assets/icons/png/alarm-clock.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/breakfast.png') {
                                  valueImage = 'assets/icons/png/breakfast.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/celeb.png') {
                                  valueImage = 'assets/icons/png/celeb.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/Lunch.png') {
                                  valueImage = 'assets/icons/png/Lunch.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/notepad.png') {
                                  valueImage = 'assets/icons/png/notepad.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/online-learning.png') {
                                  valueImage =
                                      'assets/icons/png/online-learning.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/settings.png') {
                                  valueImage = 'assets/icons/png/settings.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/shopping.png') {
                                  valueImage = 'assets/icons/png/shopping.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/treadmill.png') {
                                  valueImage = 'assets/icons/png/treadmill.png';
                                } else if (dropdownValue ==
                                    'assets/icons/png/travel.png') {
                                  valueImage = 'assets/icons/png/travel.png';
                                }

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userLoggedIn!.uid)
                                    .collection('tasks')
                                    .doc(widget.task?.id)
                                    .update(
                                  {
                                    'image': valueImage,
                                  },
                                );
                              },
                              items: <String>[
                                'assets/icons/png/alarm-clock.png',
                                'assets/icons/png/breakfast.png',
                                'assets/icons/png/celeb.png',
                                'assets/icons/png/Lunch.png',
                                'assets/icons/png/notepad.png',
                                'assets/icons/png/online-learning.png',
                                'assets/icons/png/settings.png',
                                'assets/icons/png/shopping.png',
                                'assets/icons/png/treadmill.png',
                                'assets/icons/png/travel.png',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Image.asset(value),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffEEEEEE),
                          ),
                          child: TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                              hintStyle: TextStyle(
                                fontFamily: 'Raleway',
                                color: Color.fromARGB(255, 118, 118, 118),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffEEEEEE),
                          ),
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                fontFamily: 'Raleway',
                                color: Color.fromARGB(255, 118, 118, 118),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffEEEEEE),
                          ),
                          child: DateTimeField(
                            initialValue: widget.task?.date,
                            controller: dateController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Date',
                              hintStyle: TextStyle(
                                fontFamily: 'Raleway',
                                color: Color.fromARGB(
                                  255,
                                  118,
                                  118,
                                  118,
                                ),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            validator: (dateTime) =>
                                dateTime == null ? 'Not valid input' : null,
                            format: DateFormat('yyyy-MM-dd'),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                                initialDate: currentValue ?? DateTime.now(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            primary: const Color(0xffEEEEEE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: FittedBox(
                            child: Text(
                              getText(),
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 20,
                                color: Color.fromARGB(
                                  255,
                                  118,
                                  118,
                                  118,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () => pickTime(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Turn On Notification',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Color.fromARGB(
                                  255,
                                  82,
                                  82,
                                  82,
                                ),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Switch(
                              activeColor: const Color(0xffFFC045),
                              value: status,
                              onChanged: (value) {
                                setState(() {
                                  status = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffFFC045),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              final task = TaskModel(
                                id: widget.task?.id ?? '',
                                title: titleController.text,
                                description: descriptionController.text,
                                date: DateTime.parse(dateController.text),
                              );

                              if (isEditing) {
                                updateTask(task);
                              } else {
                                createTask(task);
                              }

                              final action = isEditing ? 'Edited' : 'Added';
                              final snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  '$action ${titleController.text} to Firebase!',
                                  style: const TextStyle(
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
                            child: Text(
                              isEditing ? 'Update Task' : 'Create Task',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget taskForm() {
    final isEditing = widget.task != null;

    return FloatingActionButton(
      onPressed: () {
        modalBottomSheet(isEditing);
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: const Color(0xffFFC045),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: taskForm(),
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
                          const Text(
                            'Hello, Bro',
                            style: TextStyle(
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
                          buildTasks(),
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
                                'Upcoming Tasks',
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
                                Image.asset('assets/icons/png/shopping.png',
                                    height: 35),
                                const SizedBox(width: 20),
                                const Text(
                                  'Grocery Shopping',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Raleway',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  '04:00 PM',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Raleway',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
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
                      Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {},
                              foregroundColor: Colors.grey,
                              backgroundColor:
                                  const Color.fromARGB(0, 0, 0, 255),
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
                                  builder: (BuildContext context) =>
                                      AlertDialog(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    color:
                                                        const Color(0xffFFC045),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff3F3F3F),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(width: 16),
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xffFFC045),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff3F3F3F),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                              backgroundColor:
                                  const Color.fromARGB(0, 0, 0, 255),
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
                              Image.asset('assets/icons/png/alarm-clock.png',
                                  height: 35),
                              const SizedBox(width: 20),
                              const Text(
                                'Wake Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                '06:30 AM',
                                style: TextStyle(
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
                      Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {},
                              foregroundColor: Colors.grey,
                              backgroundColor:
                                  const Color.fromARGB(0, 0, 0, 255),
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
                                  builder: (BuildContext context) =>
                                      AlertDialog(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    color:
                                                        const Color(0xffFFC045),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff3F3F3F),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(width: 16),
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xffFFC045),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff3F3F3F),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                              backgroundColor:
                                  const Color.fromARGB(0, 0, 0, 255),
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
                              Image.asset('assets/icons/png/breakfast.png',
                                  height: 35),
                              const SizedBox(width: 20),
                              const Text(
                                'Breakfast',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                '08:00 AM',
                                style: TextStyle(
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
                      Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {},
                              foregroundColor: Colors.grey,
                              backgroundColor:
                                  const Color.fromARGB(0, 0, 0, 255),
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
                                  builder: (BuildContext context) =>
                                      AlertDialog(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    color:
                                                        const Color(0xffFFC045),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff3F3F3F),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(width: 16),
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xffFFC045),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff3F3F3F),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                              backgroundColor:
                                  const Color.fromARGB(0, 0, 0, 255),
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
                              Image.asset('assets/icons/png/Lunch.png',
                                  height: 35),
                              const SizedBox(width: 20),
                              const Text(
                                'Lunch',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                '01:00 PM',
                                style: TextStyle(
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
                      Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {},
                              foregroundColor: Colors.grey,
                              backgroundColor:
                                  const Color.fromARGB(0, 0, 0, 255),
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
                                  builder: (BuildContext context) =>
                                      AlertDialog(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    color:
                                                        const Color(0xffFFC045),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff3F3F3F),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(width: 16),
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xffFFC045),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff3F3F3F),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                              backgroundColor:
                                  const Color.fromARGB(0, 0, 0, 255),
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
                              Image.asset('assets/icons/png/shopping.png',
                                  height: 35),
                              const SizedBox(width: 20),
                              const Text(
                                'Grocery Shopping',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                '04:00 PM',
                                style: TextStyle(
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
