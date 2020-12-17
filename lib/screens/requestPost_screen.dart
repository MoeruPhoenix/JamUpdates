import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/services/firebaseOperations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName, title, desc, reportType, loc, postStatus;
  String dropdownValue = 'Report/Complaint';

  File selectedImage;
  bool _isLoading = false;
  CrudMethods crudMethods = new CrudMethods();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      if(authorName == null)
        {
          authorName = "Anonymous";
        }

      if (reportType == "Missing Poster" || reportType == "Community Post") {
        postStatus = "unverified";
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("blogImages")
            .child("${randomAlphaNumeric(9)}.jpg");

        final StorageUploadTask task =
            firebaseStorageRef.putFile(selectedImage);

        var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
        print("this is url $downloadUrl");

        Map<String, String> blogMap = {
          "imgUrl": downloadUrl,
          "authorName": authorName,
          "title": title,
          "desc": desc,
          "location": loc,
          "status": postStatus
        };
        crudMethods.addUserPosts(blogMap).then((result) {
          Navigator.pop(context);
        });
      } else {
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("reportImages")
            .child("${randomAlphaNumeric(9)}.jpg");

        final StorageUploadTask task =
            firebaseStorageRef.putFile(selectedImage);

        var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
        print("this is url $downloadUrl");

        Map<String, String> blogMap = {
          "desc": desc,
          "imgUrl": downloadUrl,
          "location": loc,
          "name": authorName,
          "title": title,
        };
        crudMethods.addUserReports(blogMap).then((result) {
          Navigator.pop(context);
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Submit a ",
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            Text(
              "Post",
              style: TextStyle(fontSize: 22, color: Colors.yellowAccent),
            )
          ],
        ),
        backgroundColor: Colors.green,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [Icon(Icons.file_upload), Text("Submit")],
                )),
          )
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: selectedImage != null
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                height: 170,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    selectedImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                height: 170,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black45,
                                    ),
                                    Text("Tap to select image.")
                                  ],
                                ),
                              )),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Text("Type of Report:         "),
                              DropdownButton<String>(
                                value: dropdownValue,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.green),
                                underline: Container(
                                  height: 2,
                                  color: Colors.green,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    reportType = dropdownValue;
                                  });
                                },
                                items: <String>[
                                  'Report/Complaint',
                                  'Missing Poster',
                                  'Community Post'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          TextField(
                            decoration: InputDecoration(hintText: "Location"),
                            onChanged: (val) {
                              loc = val;
                            },
                          ),
                          TextField(
                            decoration:
                                InputDecoration(hintText: "Name (Optional)"),
                            onChanged: (val) {
                              authorName = val;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(hintText: "Title"),
                            onChanged: (val) {
                              title = val;
                            },
                          ),
                          TextField(
                            decoration:
                                InputDecoration(hintText: "Description"),
                            onChanged: (val) {
                              desc = val;
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
