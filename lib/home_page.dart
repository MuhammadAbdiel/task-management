import 'package:flutter/material.dart';
import 'package:flutter_uts/all_tasks_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dropdownValue = 'assets/icons/png/alarm-clock.png';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              constraints: BoxConstraints.loose(
                Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 0.65),
              ),
              isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (BuildContext context) {
                return Center(
                  child: SingleChildScrollView(
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
                            child: const TextField(
                              decoration: InputDecoration(
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
                            child: const TextField(
                              decoration: InputDecoration(
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
                            child: const TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Date',
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
                            child: const TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Time',
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Create Task',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Raleway',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
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
                          const Text(
                            'Hello, Bro',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff3F3F3F),
                            ),
                          ),
                          Image.asset(
                            'assets/images/man.png',
                            height: 50,
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
                                  Navigator.pushReplacement(
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
                                  Navigator.pushReplacement(
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
                              onPressed: (context) {},
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
                              onPressed: (context) {},
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
                              onPressed: (context) {},
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
                              onPressed: (context) {},
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
