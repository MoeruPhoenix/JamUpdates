import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/adminPublication_screen.dart';
import 'package:flutter_login_ui/screens/adminReports_screen.dart';
import 'package:flutter_login_ui/screens/adminVerifyPosts_screen.dart';
import 'package:flutter_login_ui/services/firebaseOperations.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_login_ui/widgets/dashboardItems.dart';
import 'package:getwidget/components/button/gf_button.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _dateTime;
  DateTime _updatedAt = DateTime.now();

  CrudMethods crudMethods = new CrudMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[dashBg, content],
      ),
    );
  }

  get dashBg => Column(
        children: <Widget>[
          Expanded(
            child: Container(color: Colors.green),
            flex: 2,
          ),
          Expanded(
            child: Container(color: Colors.white54),
            flex: 5,
          ),
        ],
      );

  get content => Container(
        child: Column(
          children: <Widget>[
            header,
            grid,
          ],
        ),
      );

  get header => ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
        title: Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          'JamUpdates',
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
      );

  get grid => Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => ApprovePosts(),
                          ));
                    },
                    child:
                        makeDashboardItem("Approve Posts", Icons.fact_check)),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => ReportsPage(),
                          ));
                    },
                    child:
                        makeDashboardItem("View Reports", Icons.rate_review)),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => PostAnnoucement(),
                          ));
                    },
                    child: makeDashboardItem(
                        "Post Announcement", Icons.post_add_outlined)),
                InkWell(
                    onTap: () {
                      setState(() {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  contentPadding:
                                      EdgeInsets.only(left: 20, right: 20),
                                  title: Center(
                                      child: Text("Update Island Curfew",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.green))),
                                  content: Container(
                                    height: 350,
                                    width: 300,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                              "Pick the new curfew time and select \"Update Curfew\"."),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TimePickerSpinner(
                                            is24HourMode: false,
                                            normalTextStyle: TextStyle(
                                                fontSize: 24,
                                                color: Colors.grey),
                                            highlightedTextStyle: TextStyle(
                                                fontSize: 24,
                                                color: Colors.black),
                                            spacing: 50,
                                            itemHeight: 80,
                                            isForce2Digits: true,
                                            onTimeChange: (time) {
                                              setState(() {
                                                _dateTime = time;
                                                print(_dateTime);
                                              });
                                            },
                                          ),
                                          GFButton(
                                            color: Colors.green,
                                            child: new Text(
                                              'Update Curfew',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              uploadCurfew();
                                            },
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          child: GFButton(
                                            color: Colors.red,
                                            child: new Text(
                                              'Close',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ]);
                            });
                      });
                    },
                    child: makeDashboardItem(
                        "Update Curfew", Icons.update_outlined)),
              ]),
        ),
      );

  uploadCurfew() async {
    Map<String, DateTime> curfewMap = {
      "curfewTime": _dateTime,
      "updatedAt": _updatedAt,
    };
    crudMethods.addCurfewData(curfewMap).then((result) {
      Navigator.pop(context);
    });
  }
}
