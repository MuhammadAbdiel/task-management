// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uts/models/user_model.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<bool> isSelected = List.generate(2, (_) => false);

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  User? userLoggedIn = FirebaseAuth.instance.currentUser!;
  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .doc(userLoggedIn!.uid)
        .get()
        .then(
      (value) {
        setState(() {
          userModel = UserModel.fromJson(value.data());
          firstNameController.text = userModel.firstName.toString();
          lastNameController.text = userModel.lastName.toString();
          emailController.text = user.email!;
        });
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 32,
              right: 24,
              left: 24,
            ),
            child: Form(
              key: formKey,
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
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3F3F3F),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(50),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xffEEEEEE),
                            ),
                            child: Image.asset(
                              userModel.gender == 'man'
                                  ? 'assets/images/man.png'
                                  : 'assets/images/woman.png',
                              height: 100,
                            ),
                          ),
                          const SizedBox(height: 48),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xffEEEEEE),
                            ),
                            child: TextFormField(
                              validator: (text) => text != null && text.isEmpty
                                  ? 'Not valid input'
                                  : null,
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'First Name',
                                hintStyle: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Color.fromARGB(255, 118, 118, 118),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xffEEEEEE),
                            ),
                            child: TextFormField(
                              validator: (text) => text != null && text.isEmpty
                                  ? 'Not valid input'
                                  : null,
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Last Name (Optional)',
                                hintStyle: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Color.fromARGB(255, 118, 118, 118),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
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
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const HomePage(),
                                //   ),
                                // );
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
