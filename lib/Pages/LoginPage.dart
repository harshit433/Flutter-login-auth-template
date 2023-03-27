import 'package:first_app/Services/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Pages/HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:first_app/Services/otp_page.dart';
import 'CreateProfilePage.dart';
import 'SignupPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
// =========================================Declaring are the required variables=============================================
  final _formKey = GlobalKey<FormState>();

  var id = TextEditingController();
  var password = TextEditingController();
  var phone = TextEditingController();

  bool notvisible = true;
  bool notVisiblePassword = true;
  Icon passwordIcon = const Icon(Icons.visibility);
  bool emailFormVisibility = true;
  bool otpVisibilty = false;

  String? emailError;
  String? passError;
  String? _verificationCode;

// ================================================Password Visibility function ===========================================

  void passwordVisibility() {
    if (notVisiblePassword) {
      passwordIcon = const Icon(Icons.visibility);
    } else {
      passwordIcon = const Icon(Icons.visibility_off);
    }
  }

// ================================================Login Function ======================================================
  login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: id.text.toString(), password: password.text.toString());
      isEmailVerified();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        emailError = 'Enter valid email ID';
      }
      if (e.code == 'wrong-password') {
        passError = 'Enter correct password';
      }
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You are not registed. Sign Up now")));
      }
    }
    setState(() {});
  }
// ================================================Login Using phone number ==============================================

  signinphone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone.text.toString(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            first_login();
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          const SnackBar(
              content: Text('The provided phone number is not valid.'));
        }
      },
      codeSent: (String? verificationId, int? resendToken) async {
        setState(() {
          otpVisibilty = true;
          _verificationCode = verificationId;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OTPPage(id: _verificationCode, phone: phone.text.toString());
          }));
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
    );
  }

// ================================================Login Using Google function ==============================================

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => {
              if (value.user != null) {first_login()}
            });
  }

// ================================================= Checking if email is verified =======================================

  void isEmailVerified() {
    User user = FirebaseAuth.instance.currentUser!;
    if (user.emailVerified) {
      first_login();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email is not verified.')));
    }
  }

// ================================================= Checking First time login ===============================================

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

// ================================================Building The Screen ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                // Topmost image
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    'assets/images/login.jpg',
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Column(
                    children: [
                      // Login Text
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Login',
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
                      Visibility(
                        visible: emailFormVisibility,
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                      icon: const Icon(
                                        Icons.alternate_email_outlined,
                                        color: Colors.grey,
                                      ),
                                      labelText: 'Email ID',
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              emailFormVisibility =
                                                  !emailFormVisibility;
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.phone_android_rounded))),
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
                                              notVisiblePassword =
                                                  !notVisiblePassword;
                                              passwordVisibility();
                                            });
                                          },
                                          icon: passwordIcon)),
                                  controller: password,
                                )
                              ],
                            )),
                      ),
                      Visibility(
                          visible: !emailFormVisibility,
                          child: Form(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  icon: const Icon(
                                    Icons.phone_android_rounded,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Phone Number',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          emailFormVisibility =
                                              !emailFormVisibility;
                                        });
                                      },
                                      icon: const Icon(
                                          Icons.alternate_email_rounded))),
                              controller: phone,
                            ),
                          )),

                      const SizedBox(height: 13),

                      // Forgot Password
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.indigo),
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RESETpasswordPage();
                              }));
                            },
                          ),
                        ),
                      ),
                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          if (emailFormVisibility) {
                            login();
                            first_login();
                          } else {
                            signinphone();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Center(
                            child: Text(
                          "Login",
                          style: TextStyle(fontSize: 15),
                        )),
                      ),
                      // Sized box
                      const SizedBox(height: 15),
                      // Divider and OR
                      Stack(
                        children: [
                          const Divider(
                            thickness: 1,
                          ),
                          Center(
                            child: Container(
                              color: Colors.white,
                              width: 70,
                              child: const Center(
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      fontSize: 20,
                                      backgroundColor: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Sized box
                      const SizedBox(height: 20),
                      // Login with google
                      ElevatedButton.icon(
                        onPressed: () {
                          signInWithGoogle();
                          first_login();
                        },
                        icon: Image.asset(
                          'assets/images/google_logo.png',
                          width: 20,
                          height: 20,
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                            backgroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        label: const Center(
                            child: Text(
                          "Login with Google",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontFamily: 'Poppins'),
                        )),
                      ),
                      // Sized box
                      const SizedBox(height: 25),
                      // Register button
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "New to the App? ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          GestureDetector(
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignUpPage();
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
          ),
        ));
  }
}
