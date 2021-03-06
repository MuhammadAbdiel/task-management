// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_uts/models/task_model.dart';
import 'package:flutter_uts/models/user_model.dart';
import 'package:intl/intl.dart';

class TasksPage extends StatefulWidget {
  final TaskModel? task;

  const TasksPage({Key? key, this.task}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TimeOfDay? time;
  var dropdownValue = 'assets/icons/png/activities.png';
  bool status = false;
  var valueImage = '';
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
      dateController.text = DateFormat('yyyy-MM-dd').format(task.date);
    }
  }

  String getText() {
    if (time == null) {
      if (widget.task != null) {
        final task = widget.task!;

        if (task.time != '') {
          return task.time;
        }
        return 'Select Time';
      }
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

    if (widget.task != null) {
      final task = widget.task!;

      FirebaseFirestore.instance
          .collection('users')
          .doc(userLoggedIn!.uid)
          .collection('tasks')
          .doc(task.id)
          .update(
        {
          'time': getText(),
        },
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.only(
                top: 32,
                right: 24,
                left: 24,
              ),
              child: Column(
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
                      Text(
                        isEditing ? "Update Task" : "Create Task",
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3F3F3F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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
                        onChanged: isEditing
                            ? null
                            : (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });

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
                              },
                        items: <String>[
                          'assets/icons/png/activities.png',
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
                              child: Image.asset(
                                widget.task?.image == null
                                    ? value
                                    : widget.task?.image == ''
                                        ? 'assets/icons/png/activities.png'
                                        : widget.task!.image,
                              ),
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
                        floatingLabelAlignment: FloatingLabelAlignment.center,
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
                        floatingLabelAlignment: FloatingLabelAlignment.center,
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
                    child: SizedBox(
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
                        value: isEditing
                            ? widget.task!.turnOnNotification
                            : status,
                        onChanged: (value) {
                          setState(() {
                            isEditing
                                ? widget.task!.turnOnNotification = value
                                : status = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
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
                        TaskModel task = TaskModel(
                          id: '',
                          image: '',
                          title: '',
                          description: '',
                          date: DateTime.parse('0000-00-00'),
                          time: '',
                          turnOnNotification: false,
                        );

                        if (isEditing) {
                          task = TaskModel(
                            id: widget.task?.id ?? '',
                            image: widget.task!.image,
                            title: titleController.text,
                            description: descriptionController.text,
                            date: DateTime.parse(dateController.text),
                            time: getText(),
                            turnOnNotification: widget.task!.turnOnNotification,
                          );
                        } else {
                          task = TaskModel(
                            id: widget.task?.id ?? '',
                            image: valueImage,
                            title: titleController.text,
                            description: descriptionController.text,
                            date: DateTime.parse(dateController.text),
                            time: getText(),
                            turnOnNotification: status,
                          );
                        }

                        final re = RegExp(r'T*');
                        final dateSplit = task.date.toIso8601String().split(re);
                        final timeSplit = task.time.split(re);

                        if (isEditing) {
                          updateTask(task);
                        } else {
                          createTask(task);
                        }

                        final year = int.parse(
                            '${dateSplit[0]}${dateSplit[1]}${dateSplit[2]}${dateSplit[3]}');
                        final month =
                            int.parse('${dateSplit[5]}${dateSplit[6]}');
                        final date =
                            int.parse('${dateSplit[8]}${dateSplit[9]}');
                        final hour =
                            int.parse('${timeSplit[0]}${timeSplit[1]}');
                        final minute =
                            int.parse('${timeSplit[3]}${timeSplit[4]}');

                        if (task.turnOnNotification) {
                          AndroidAlarmManager.oneShotAt(
                            DateTime(year, month, date, hour, minute, 00),
                            1,
                            fireAlarm,
                          );
                        } else {
                          AndroidAlarmManager.cancel(1);
                        }

                        final action = isEditing ? 'Edited' : 'Added';
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            '${titleController.text} $action successfully',
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
      ),
    );
  }
}

void setNotification() async {
  print('Alaram Tiggered trigger notification set');

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const initializationSettingsIOS = IOSInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) async {
      print("selected notification");
    },
  );

  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const iOSPlatformChannelSpecifics = IOSNotificationDetails();
  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    1,
    'Notification',
    'Task Schedule',
    platformChannelSpecifics,
    payload: DateTime.now().toString(),
  );
}

void fireAlarm() {
  print('Alarm Fired at ${DateTime.now()}');
  setNotification();
}
