import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/adminDashboard_screen.dart';
import 'package:flutter_login_ui/screens/userHome_screen.dart';

class RoleRouting extends StatelessWidget {
  const RoleRouting({Key key, this.user});
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return checkUserRole(snapshot.data);
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }

  checkUserRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: Text('no data set in the userId document in firestore'),
      );
    }
    print(snapshot.data['role']);
    if (snapshot.data['role'] == 'admin') {
      return Dashboard();
    } else {
      return HomePage();
    }
  }
}