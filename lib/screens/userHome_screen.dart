import 'package:flutter/cupertino.dart';
import 'package:flutter_login_ui/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/requestPost_screen.dart';
import 'package:flutter_login_ui/services/firebaseOperations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();

  Stream blogsStream;
  Stream curfewStream;

  Widget _blogsList() {
    return Container(
      child: blogsStream != null
          ? Column(
              children: <Widget>[
                StreamBuilder(
                  stream: blogsStream,
                  builder: (context, snapshot) {
                    return Container(
                      height: 250,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: snapshot.data.documents.length,
                          scrollDirection: Axis.horizontal,
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
                                                Center(child: Text("Details")),
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
                                                                  'authorName']),
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
                                    .data.documents[index].data['authorName'],
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
    // crudMethods.getCurfewData().then((result) {
    //   setState(() {
    //     curfewStream = result;
    //   });
      crudMethods.getCurfewDatas().then((result) {
      setState(() {
        curfewStream = result;
        print(result);
      });
    });

    crudMethods.getAnnouncementsData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    String formattedNow = DateFormat.yMMMMd('en_US').format(now);

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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  height: 200,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://assets.weforum.org/project/image/cH2WBDZXOrHDj62VMy0U3BonpAsY8-qi5kRzqqXjIzw.jpeg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black45.withOpacity(0.3),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            StreamBuilder(
                                stream: curfewStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  var snapCurfew = snapshot.data.documents[0].data['curfewTime'].toDate();
                                  String snapTime = DateFormat.jm().format(snapCurfew);
                                  return Text(
                                     'Curfew Time: ' +
                                    // snapshot.data.documents[0].data['curfewTime'].toString(),
                                         snapTime,
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontSize: 28,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.white),
                                   );
                                }),
                            SizedBox(
                              height: 8,
                            ),
                            StreamBuilder(
                              stream: curfewStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                var snapCurfew = snapshot.data.documents[0].data['updatedAt'].toDate();
                                String snapTime = DateFormat.yMd().add_jm().format(snapCurfew);

                                return Text(
                                  'Last Updated: ' + snapTime,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.green),
                                );
                              }
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text('Today\'s Date is: $formattedNow',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white60))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Announcements",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _blogsList()
              ])),
      drawer: GFDrawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GFDrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              currentAccountPicture: GFAvatar(
                radius: 80.0,
                backgroundImage: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSezzUWQA86i5SeEmfJP83mPykyLVrB93sjFA&usqp=CAU",
                ),
              ),
              otherAccountsPictures: <Widget>[
                GFAvatar(
                  child: Text("ab"),
                )
              ],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('user name'),
                  Text('user@userid.com'),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: null,
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Submit Post'),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => CreateBlog(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton.extended(
            label: Text('Submit a report'),
            icon: Icon(Icons.add),
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateBlog()));
            }),
      ),
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
      height: 200,
      padding: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            child: Image.network(
              widget.imgUrl,
              height: 150,
              width: 200,
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
