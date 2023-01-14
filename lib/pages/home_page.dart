//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/10
//
import 'package:flutter/material.dart';
import 'package:walden/calendar/calendar_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 199.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 120,
                  color: Colors.orange,
                  child: Text("9999"),
                ),
              ],
            ),
          ),
          Material(
            elevation: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildAppBar(),
                CalendarBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    var mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;
    final appBarLeading = Row(
      children: [
        SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "周二，10",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "1月，2023",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          appBarLeading,
          Padding(
            padding: EdgeInsets.only(right: statusBarHeight / 2),
            child: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
