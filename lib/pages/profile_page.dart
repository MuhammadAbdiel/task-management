// ignore_for_file: unnecessary_null_comparison, avoid_print, unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uts/google_sign_in_provider.dart';
import 'package:flutter_uts/models/user_model.dart';
import 'package:flutter_uts/pages/edit_profile.dart';
import 'package:flutter_uts/pages/sign_up.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

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
                      "Pengaturan Akun",
                      style: TextStyle(
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
                  width: double.infinity,
                  height: 130,
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
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
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
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              provider.googleSignIn.currentUser != null
                                  ? Text(
                                      user.displayName!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Raleway',
                                        color: Color.fromARGB(255, 82, 82, 82),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : Text(
                                      '${userModel.firstName.toString()} ${userModel.lastName.toString()}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Raleway',
                                        color: Color.fromARGB(255, 82, 82, 82),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                              Text(
                                user.email!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  color: Color.fromARGB(255, 82, 82, 82),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Column(
                  children: [
                    provider.googleSignIn.currentUser == null
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfile(),
                                ),
                              );
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.person, size: 35),
                                SizedBox(width: 16),
                                Text(
                                  'Akun',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Raleway',
                                    color: Color.fromARGB(255, 82, 82, 82),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text(
                              'Logout',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff3F3F3F),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: const Text(
                              'Apakah anda yakin?',
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Tidak',
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
                                  const SizedBox(width: 16),
                                  InkWell(
                                    onTap: () {
                                      if (provider.googleSignIn.currentUser !=
                                          null) {
                                        provider.googleLogout(context);
                                      } else {
                                        FirebaseAuth.instance
                                            .signOut()
                                            .then((value) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUp(),
                                            ),
                                          );
                                        });
                                      }
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
                                              'Ya',
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
                      child: Row(
                        children: const [
                          Icon(Icons.logout, size: 35),
                          SizedBox(width: 16),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Raleway',
                              color: Color.fromARGB(255, 82, 82, 82),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
