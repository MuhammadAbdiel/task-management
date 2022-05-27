import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uts/login.dart';
import 'package:flutter_uts/models/user_model.dart';
import 'package:flutter_uts/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<bool> isSelected = List.generate(2, (_) => false);

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool toggleButton = true;

  void signUp(String email, String password) async {
    if (formKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => postDetailsToFireStore());
    }
  }

  postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();
    userModel.uid = user!.uid;
    userModel.email = user.email;
    userModel.firstName = firstNameController.text;
    userModel.lastName = lastNameController.text;
    if (toggleButton == true) {
      userModel.gender = 'man';
    } else {
      userModel.gender = 'woman';
    }

    await firebaseFirestore.collection('users').doc(user.uid).set(
          userModel.toJson(),
        );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.all(50),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffEEEEEE),
                      ),
                      child: Image.asset(
                        'assets/icons/png/list.png',
                      ),
                    ),
                    const SizedBox(height: 36),
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
                        controller: firstNameController,
                        keyboardType: TextInputType.name,
                        validator: (text) => text != null && text.isEmpty
                            ? 'Please enter your name!'
                            : null,
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
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        validator: (text) => text != null && text.isEmpty
                            ? 'Please enter your name!'
                            : null,
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) => text != null && text.isEmpty
                            ? 'Please enter your email correctly!'
                            : null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
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
                        obscureText: true,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (text) {
                          RegExp regExp = RegExp(r'^.{6,}$');
                          return text != null && text.isEmpty
                              ? 'Password is required!'
                              : !regExp.hasMatch(text!)
                                  ? 'Enter a valid password (Min. 6 Character)'
                                  : null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontFamily: 'Raleway',
                            color: Color.fromARGB(255, 118, 118, 118),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SizedBox(height: 8),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(20),
                      fillColor: const Color(0xffFFC045).withOpacity(0.8),
                      children: <Widget>[
                        Image.asset(
                          'assets/images/man.png',
                          height: 50,
                        ),
                        Image.asset(
                          'assets/images/woman.png',
                          height: 50,
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < isSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                            } else {
                              isSelected[buttonIndex] = false;
                            }

                            if (index == 0) {
                              toggleButton = true;
                            } else {
                              toggleButton = false;
                            }
                          }
                        });
                      },
                      isSelected: isSelected,
                    ),
                    const SizedBox(height: 32),
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
                          signUp(emailController.text, passwordController.text);
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Raleway',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Do you have an account?',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffFFC045),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            // ! Solusi dari Error HomePage
                            // FirebaseAuth.instance.signOut();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const Login();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: 'Raleway',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffFFC045),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
