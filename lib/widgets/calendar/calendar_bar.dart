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
  late PageController _pc;

  final int initialPage = 9999;

  late ValueNotifier<int> _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = ValueNotifier(initialPage);
    _pc = PageController(initialPage: initialPage);
  }

  List<DateTime> getListOfDate(DateTime monthDate) {
    final dateList = <DateTime>[];
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
    return dateList;
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
            child: getWeekDayNameUI(),
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
          maxHeight: 378,
          builder: (BuildContext context, AnimationController ac) {
            return Column(
              children: [
                SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: _pageIndex,
                  builder: (BuildContext context, int pageIndex, Widget? child) {
                    final indexDate = calcIndexDate(pageIndex);
                    print('pageIndex: $pageIndex');
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildYearAndMonthPicker(indexDate),
                          buildMonthNavigator(pageIndex),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 5),
                Expanded(
                  child: PageView.builder(
                    controller: _pc,
                    onPageChanged: (index) {
                      _pageIndex.value = index;
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final indexDate = calcIndexDate(index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: getDaysNoUI(indexDate),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  DateTime calcIndexDate(int index) {
    final interval = index - initialPage;
    final currentDate = DateTime.now();
    return DateTime(currentDate.year, currentDate.month + interval + 1, 0);
  }

  Widget buildYearAndMonthPicker(DateTime indexDate) {
    var monthYear = DateFormat("yyyy, MMMM").format(indexDate);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 12),
        Text(
          monthYear,
          strutStyle: StrutStyle(
            height: 1,
            leading: 0.5,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: ThemeData.light().primaryColor,
          size: 14,
        ),
      ],
    );
  }

  Widget buildMonthNavigator(int pageIndex) {
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
              _pc.animateToPage(pageIndex - 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
            child: Container(
              padding: EdgeInsets.only(left: 6, right: 8),
              child: Icon(
                Icons.arrow_back_ios,
                color: ThemeData.light().primaryColor,
                size: 20,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _pc.animateToPage(pageIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 6),
              child: Icon(
                Icons.arrow_forward_ios,
                color: ThemeData.light().primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getWeekDayNameUI() {
    final items = ["日", "一", "二", "三", "四", "五", "六"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [for (var e in items) Expanded(child: Center(child: Text(e)))],
    );
  }

  List<Widget> getDaysNoUI(DateTime indexDate) {
    List<DateTime> dateList = getListOfDate(indexDate);
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
                                      : indexDate.month == date.month
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
