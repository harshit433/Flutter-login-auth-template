import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'CreateProfilePage.dart';
import 'LoginPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  String email = '';
  String pass = '';

  bool notvisible = true;
  bool notVisiblePassword = true;
  Icon passwordIcon = const Icon(Icons.visibility);

  var id = TextEditingController();
  var password = TextEditingController();

  void passwordVisibility() {
    if (notVisiblePassword) {
      passwordIcon = const Icon(Icons.visibility);
    } else {
      passwordIcon = const Icon(Icons.visibility_off);
    }
  }

  void sendVerificationEmail() {
    User user = FirebaseAuth.instance.currentUser!;
    user.sendEmailVerification();
  }

  create_user() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: id.text.toString().trim(),
            password: password.text.toString().trim())
        .whenComplete(() {
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        sendVerificationEmail();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Verification mail has been to registed Email ID. Verify your account and login again')));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              // Topmost image
              Container(
                height: size.height / 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    'assets/images/signup.jpg',
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Column(
                  children: [
                    // Login Text
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                    // Sized box
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                        child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.alternate_email_outlined,
                              color: Colors.grey,
                            ),
                            labelText: 'Email ID',
                          ),
                          controller: id,
                        ),
                        TextFormField(
                          obscureText: notvisible,
                          decoration: InputDecoration(
                              icon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.grey,
                              ),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      notvisible = !notvisible;
                                      notVisiblePassword = !notVisiblePassword;
                                      passwordVisibility();
                                    });
                                  },
                                  icon: passwordIcon)),
                          controller: password,
                        )
                      ],
                    )),

                    const SizedBox(height: 13),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          child: const Text(
                            'By signing up, you agree to our Terms & conditions and Privacy Policy',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                    // SignUp Button
                    ElevatedButton(
                      onPressed: () {
                        create_user();
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Center(
                          child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 15),
                      )),
                    ),

                    // Sized box
                    const SizedBox(height: 25),
                    // Login button
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Joined us before? ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        GestureDetector(
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginPage();
                            }));
                          },
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
