//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/10
//
import 'package:flutter/material.dart';
import 'package:walden/widgets/sliding_panel.dart';
import 'package:walden/widgets/sliver_header.dart';

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
            padding: const EdgeInsets.only(top: 183.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 500,
                  color: Colors.orange,
                  child: Text("1500"),
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
                WeekBar(),
                SlidingPanel(
                  builder: (BuildContext context, AnimationController ac) {
                    return Container(color: Colors.blue, child: Text("calendar"));
                  },
                ),
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

class WeekBar extends StatelessWidget {
  const WeekBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
      ],
    );
  }
}
