import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../Pages/CreateProfilePage.dart';
import '../Pages/HomePage.dart';
import 'package:first_app/Pages/LoginPage.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key, required this.id, required this.phone});

  final String? id;
  final String phone;

  @override
  State<StatefulWidget> createState() => _OTPpage();
}

class _OTPpage extends State<OTPPage> {
  first_login() async {
    DateTime? creation =
        FirebaseAuth.instance.currentUser!.metadata.creationTime;
    DateTime? lastlogin =
        FirebaseAuth.instance.currentUser!.metadata.lastSignInTime;

    if (creation == lastlogin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return CreateProfilePage();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MyHomePage(title: "hello");
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = widget.phone;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 90,
            ),
            SizedBox(width: 300, child: Image.asset('assets/images/otp.webp')),
            const SizedBox(height: 40),
            Container(
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Enter OTP',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                )),
            Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'An 6 digit code has been sent to \n +91 $phoneNumber',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: OtpTextField(
                  numberOfFields: 6,
                  borderColor: Colors.black,
                  showFieldAsBox: true,
                  borderRadius: BorderRadius.circular(14),
                  fillColor: const Color.fromRGBO(247, 247, 247, 1),
                  filled: true,
                  showCursor: true,
                  onSubmit: (String code) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: widget.id!, smsCode: code))
                          .then((value) async {
                        if (value.user != null) {
                          first_login();
                        }
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-verification-code') {
                        const SnackBar(content: Text('Invalid OTP'));
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
