import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Pages/LoginPage.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            signOut();
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.logout_rounded),
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.network(
                    'https://geographical.co.uk/wp-content/uploads/somalaya-mountain-range-title.jpg')),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Oeschinen Lake Campground',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Kanderesteg, Iceland',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )),
                    Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.red[500]),
                            const Text('41')
                          ],
                        ))
                  ],
                )),
          ],
        ));
  }
}
