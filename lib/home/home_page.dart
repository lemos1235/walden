//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/10
//
import 'package:flutter/material.dart';
import 'package:walden/home/widgets/calendar_bar.dart';
import 'package:walden/widgets/sliding_panel.dart';

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
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 36 + (MediaQuery.of(context).size.width - 30) / 7 + kIndicatorHeight + 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 120,
                  color: Colors.orange,
                  child: const Text("9999"),
                ),
              ],
            ),
          ),
          const Material(
            elevation: 2,
            child: CalendarBar(),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const appBarLeading = Row(
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
    return AppBar(
      elevation: 0,
      leadingWidth: 100,
      leading: appBarLeading,
      actions: [
        const Icon(Icons.settings),
        SizedBox(width: statusBarHeight / 2),
      ],
    );
  }
}
