import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RESETpasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RESETpassword();
}

class _RESETpassword extends State<RESETpasswordPage> {
  @override
  var email = TextEditingController();

  reset_password() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.text.toString());
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                  height: 300,
                  child: Image.asset('assets/images/reset_password.jpg')),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Forgot \nPassword?',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Don't worry! It happens. Please enter the \naddress associated with the account.",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Form(
                    child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email_rounded,
                          color: Colors.grey)),
                )),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  reset_password();
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Center(
                    child: Text(
                  "Reset",
                  style: TextStyle(fontSize: 15),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
