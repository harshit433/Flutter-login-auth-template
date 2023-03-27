import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('/Users');

    addUser() {
      // Call the user's CollectionReference to add a new user
      return users.doc('0002').set({
        'First name': 'Harshit',
        'Age': 20,
        'Mobile': 8700510741,
        'Address': 'XYZ'
      }).then((value) => print('Added'));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}
