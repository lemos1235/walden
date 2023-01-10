//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/10
//
import 'package:flutter/material.dart';

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
      body: Text("hello"),
    );
  }

  AppBar buildAppBar() {
    var mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;

    final appBarLeading = Row(
      children: [
        SizedBox(width: 12),
        Column(
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
      toolbarHeight: 50,
      leadingWidth: 100,
      leading: appBarLeading,
      actions: [
        Icon(Icons.settings),
        SizedBox(width: statusBarHeight / 2),
      ],
      bottom: WeekBar(),
    );
  }

}

class WeekBar extends StatefulWidget implements PreferredSizeWidget {
  const WeekBar({super.key});

  @override
  State<WeekBar> createState() => _WeekBarState();

  @override
  Size get preferredSize => Size.fromHeight(120);
}

class _WeekBarState extends State<WeekBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.preferredSize.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.black45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("日"),
                  Text("一"),
                  Text("二"),
                  Text("三"),
                  Text("四"),
                  Text("五"),
                  Text("六"),
                ],
              ),
            ),
          ),
          Container(
            color: Color(0x675EAFCC),
            height: 48,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
