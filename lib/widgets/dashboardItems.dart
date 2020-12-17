import 'package:flutter/material.dart';

Card makeDashboardItem(String title, IconData icon) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[Icon(icon, size: 50), SizedBox(height: 10), Text(title)],
      ),
    ),
  );
}