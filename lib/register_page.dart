import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  child: Image.asset('assets/icons/png/taskly_logo.png'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
