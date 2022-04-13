import 'package:flutter/material.dart';
import 'package:flutter_uts/home_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 32, right: 24, left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
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
                Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
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
                        onPressed: (context) {},
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'April 7, 2021',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
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
                        backgroundColor: const Color.fromARGB(0, 0, 0, 255),
                        icon: Icons.edit,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'April 7, 2021',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
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
                        backgroundColor: const Color.fromARGB(0, 0, 0, 255),
                        icon: Icons.edit,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
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
                        Image.asset('assets/icons/png/Lunch.png', height: 35),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'April 7, 2021',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
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
                        backgroundColor: const Color.fromARGB(0, 0, 0, 255),
                        icon: Icons.edit,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'April 7, 2021',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
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
                      ],
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
