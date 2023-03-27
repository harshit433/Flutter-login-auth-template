import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/CreateProfilePage.dart';
import 'Pages/SignupPage.dart';
import 'firebase_options.dart';
import 'Pages/LoginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  page() {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      print("Logged in");
      return LoginPage();
    } else {
      return const MyHomePage(title: "HomePage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: page());
  }
}
