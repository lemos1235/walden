//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/12
//
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walden/widgets/sliding_panel.dart';

class CalendarBar extends StatefulWidget {
  const CalendarBar({Key? key}) : super(key: key);

  @override
  State<CalendarBar> createState() => _CalendarBarState();
}

class _CalendarBarState extends State<CalendarBar> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    setListOfDate(currentMonthDate);
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    //上个月的最后一天零点
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    //判断上个月末是否是星期六，不是的话当前月需要显示上个月的最后一周中的最后几天
    if (newDate.weekday == 7) {
      previousMothDay = 1;
      dateList.add(newDate);
    } else if (newDate.weekday < 6) {
      previousMothDay = newDate.weekday + 1;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

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
              children: getWeekDayNameUI(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFb6d7e3),
              borderRadius: BorderRadius.circular(5),
            ),
            height: 48,
          ),
        ),
        SlidingPanel(
          maxHeight: 340,
          builder: (BuildContext context, AnimationController ac) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildYearAndMonthPicker(),
                      buildMonthNavigator(),
                    ],
                  ),
                ),
                ...getDaysNoUI(),
              ],
            );
          },
        ),
      ],
    );
  }

  List<Widget> getWeekDayNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat.E().format(dateList[i]).replaceAll("周", ""),
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ThemeData.light().primaryColor),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  Widget buildYearAndMonthPicker() {
    var monthYear = DateFormat("MMM, yyyy").format(currentMonthDate);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            monthYear,
            strutStyle: StrutStyle(
              height: 1,
              leading: 0.3,
            ),
          ),
        ),
        Icon(
          Icons.navigate_next,
          color: ThemeData.light().primaryColor,
        ),
      ],
    );
  }

  Widget buildMonthNavigator() {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                currentMonthDate = DateTime(currentMonthDate.year, currentMonthDate.month, 0);
                setListOfDate(currentMonthDate);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: ThemeData.light().primaryColor,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                currentMonthDate = DateTime(currentMonthDate.year, currentMonthDate.month + 2, 0);
                setListOfDate(currentMonthDate);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: ThemeData.light().primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    //dateList.length 为 42，一行是 7 列，总共是 6 行。
    for (int i = 0; i < dateList.length / 7; i++) {
      //当前行
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        bool isToday = DateTime.now().day == date.day &&
            DateTime.now().month == date.month &&
            DateTime.now().year == date.year;
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    // 当前行的所有日期
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {
                          // 选区
                          print('点击了');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                  // 当天的高亮显示
                                  color: isToday
                                      ? ThemeData.light().primaryColor
                                      : currentMonthDate.month == date.month
                                          ? Colors.black
                                          //不是当前月的，灰度显示
                                          : Colors.grey.withOpacity(0.6),
                                  fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 当前日期底部的高亮点
                    // Positioned(
                    //   bottom: 9,
                    //   right: 0,
                    //   left: 0,
                    //   child: Container(
                    //     height: 6,
                    //     width: 6,
                    //     decoration: BoxDecoration(
                    //         color: DateTime.now().day == date.day &&
                    //                 DateTime.now().month == date.month &&
                    //                 DateTime.now().year == date.year
                    //             ? ThemeData.light().primaryColor
                    //             : Colors.transparent,
                    //         shape: BoxShape.circle),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }
}
