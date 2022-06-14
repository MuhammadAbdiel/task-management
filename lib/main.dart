import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uts/google_sign_in_provider.dart';
import 'package:flutter_uts/pages/home_page.dart';
import 'package:flutter_uts/pages/main_page.dart';
import 'package:flutter_uts/service/notification_service.dart';
import 'package:flutter_uts/styles/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   super.initState();

  //   NotificationService.init(initSchedule: true);
  //   listenNotifications();
  // }

  // void listenNotifications() =>
  //     NotificationService.onNotifications.stream.listen(onClickedNotification);

  // void onClickedNotification(String? payload) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => const HomePage(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: primaryColor,
        ),
        home: const MainPage(),
      ),
    );
  }
}
