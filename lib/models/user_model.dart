import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  final String uid;

  Data({this.uid});

  final CollectionReference UserCollection =
      Firestore.instance.collection('users');

  Future userData(String firstName, String lastName, String gender,
      String location, String role) async {
    return await UserCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'location': location,
      'role': role,
    });
  }
}
