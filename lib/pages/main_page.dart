import 'package:flutter/material.dart';
import 'package:flutter_uts/pages/sign_up.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/png/list.png',
                      height: 50,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      'Dragoyang',
                      style: TextStyle(
                        fontSize: 21,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff3F3F3F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  "Professional's life is a Mess",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 27, 27, 27),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get Organized',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 90, 90, 90),
                  ),
                ),
                const SizedBox(height: 32),
                Image.asset(
                  'assets/icons/png/laptopPerson2.png',
                  height: 420,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Raleway',
                        ),
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
  }
}
