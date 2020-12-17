import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addUserPosts(blogData) async {
    Firestore.instance.collection("blogs").add(blogData).catchError((e) {
      print(e);
    });
  }

  Future<void> addUserReports(reportData) async {
    Firestore.instance.collection("reports").add(reportData).catchError((e) {
      print(e);
    });
  }

  Future<void> addCurfewData(curfewData) async {
    Firestore.instance.collection("curfew").add(curfewData).catchError((e) {
      print(e);
    });
  }


  updatePostData(postData) async {
    Firestore.instance.collection("blogs").document(postData).updateData({'status' : "verified"}).catchError((e){
      print(e);
    });
  }

  

  getCurfewData() async {
    return await Firestore.instance.collection("curfew").snapshots().last;
  }

  getReportsData() async {
    return await Firestore.instance.collection("reports").snapshots();
  } 
  
  getUnverifiedPostsData() async {
    return await Firestore.instance.collection("blogs").where("status", isEqualTo: "unverified").snapshots();
  }

  getCurfewDatas() async {
    return await Firestore.instance.collection("curfew").orderBy('updatedAt', descending: true).limit(1).snapshots();
  }

  getAnnouncementsData() async {
    return await Firestore.instance.collection("blogs").where("status", isEqualTo: "verified").snapshots();
  }
}