import 'package:flutter/cupertino.dart';
import 'package:flutter_login_ui/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/requestPost_screen.dart';
import 'package:flutter_login_ui/services/firebaseOperations.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  CrudMethods crudMethods = new CrudMethods();

  Stream reportsStream;

  Widget _blogsList() {
    return Container(
      child: reportsStream != null
          ? Column(
              children: <Widget>[
                StreamBuilder(
                  stream: reportsStream,
                  builder: (context, snapshot) {
                    return Container(
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          itemCount: snapshot.data.documents.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            contentPadding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            title:
                                                Center(child: Text("Report Details")),
                                            content: Container(
                                              height: 400,
                                              width: 300,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    GFCard(
                                                      elevation: 0,
                                                      boxFit: BoxFit.cover,
                                                      titlePosition:
                                                          GFPosition.start,
                                                      image: Image.network(
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data['imgUrl']),
                                                      title: GFListTile(
                                                        titleText: snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["title"],
                                                        subtitleText: snapshot
                                                            .data
                                                            .documents[index]
                                                            .data['desc'],
                                                      ),
                                                      content: Text(
                                                          "Source: " +
                                                              snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  'name']),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    child: GFButton(
                                                      color: Colors.red,
                                                      child: new Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]);
                                      });
                                });
                              },
                              child: BlogsTile(
                                authorName: snapshot
                                    .data.documents[index].data['name'],
                                title: snapshot
                                    .data.documents[index].data["title"],
                                description:
                                    snapshot.data.documents[index].data['desc'],
                                imgUrl: snapshot
                                    .data.documents[index].data['imgUrl'],
                              ),
                            );
                          }),
                    );
                  },
                )
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    crudMethods.getCurfewDatas();

    crudMethods.getReportsData().then((result) {
      setState(() {
        reportsStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Jam",
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            Text(
              "Updates",
              style: TextStyle(fontSize: 22, color: Colors.yellowAccent),
            )
          ],
        ),
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Column contents vertically,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Reports",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.only(left: 50, right: 16),
                    child: Center(child: _blogsList()))
              ])),
    );
  }
}

class BlogsTile extends StatefulWidget {
  final String imgUrl, title, description, authorName;

  BlogsTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.description,
      @required this.authorName});

  @override
  _BlogsTileState createState() => _BlogsTileState();
}

class _BlogsTileState extends State<BlogsTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            child: Image.network(
              widget.imgUrl,
              height: 180,
              width: 300,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            widget.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            widget.authorName,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
