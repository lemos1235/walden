//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/12
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walden/widgets/sliding_panel.dart';

enum CalendarMode { yearAndMonth, date }

class CalendarBar extends StatefulWidget {
  const CalendarBar({Key? key}) : super(key: key);

  @override
  State<CalendarBar> createState() => _CalendarBarState();
}

class _CalendarBarState extends State<CalendarBar> {
  final Color iconColor = Colors.deepOrange;

  DateTime startDate = DateTime(1900, 1, 1);

  late ValueNotifier<int> _pageIndex;

  late PageController _pc;

  late PageController _weeksPc;

  //当前选中的日期
  DateTime? _selectedDate;

  CalendarMode _pickerMode = CalendarMode.date;

  final GlobalKey<SlidingPanelState> _slidingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final datePageIndex = getMonthDelta(DateTime.now());
    _pageIndex = ValueNotifier(datePageIndex);
    _pc = PageController(initialPage: datePageIndex);
    final weeksPageIndex = getWeeksDelta(DateTime.now());
    _weeksPc = PageController(initialPage: weeksPageIndex);
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

  DateTime getDateByDeltaMonth(int deltaMonths) {
    return DateUtils.addMonthsToMonthDate(startDate, deltaMonths);
  }

  int getMonthDelta(DateTime dateTime) {
    DateTime dateTimeZero = DateTime(dateTime.year, dateTime.month + 1, 0);
    return DateUtils.monthDelta(startDate, dateTimeZero);
  }

  int getWeeksDelta(DateTime dateTime) {
    final diffDays = dateTime.difference(startDate).inDays;
    if (startDate.weekday == 7) {
      return (diffDays / 7).floor();
    } else {
      if (diffDays < (7 - startDate.weekday)) {
        return 0;
      } else {
        return ((diffDays - (7 - startDate.weekday)) / 7).floor() + 1;
      }
    }
  }

  DateTime getWeeksFirstDay(int deltaWeeks) {
    if (startDate.weekday == 7) {
      return startDate.add(Duration(days: deltaWeeks * 7));
    } else {
      return startDate.add(Duration(days: deltaWeeks * 7 - startDate.weekday));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        iconTheme: const IconThemeData(
          color: Colors.deepOrange,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 36,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var e in ["日", "一", "二", "三", "四", "五", "六"]) Expanded(child: Center(child: Text(e)))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: (MediaQuery.of(context).size.width - 30) / 7,
              decoration: BoxDecoration(
                color: const Color(0xffd3e9ef),
                borderRadius: BorderRadius.circular(5),
              ),
              child: _buildWeekDaysBar(),
            ),
          ),
          SlidingPanel(
            key: _slidingKey,
            maxHeight: 39 + (MediaQuery.of(context).size.width - 40) / 7 * 6,
            builder: (BuildContext context, AnimationController ac) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable: _pageIndex,
                    builder: (BuildContext context, int pageIndex, Widget? child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildYearAndMonthNavigator(pageIndex),
                            if (_pickerMode == CalendarMode.date) buildMonthNavigator(pageIndex),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: _pickerMode == CalendarMode.date ? buildDatePicker() : buildMonthYearPicker(),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// 索引周日期选择
  Widget _buildWeekDaysBar() {
    return PageView.builder(
      controller: _weeksPc,
      itemBuilder: (context, index) {
        final firstDay = getWeeksFirstDay(index);
        List<Widget> listUI = [];
        for (var i = 0; i < 7; i++) {
          DateTime date = firstDay.add(Duration(days: i));
          listUI.add(Expanded(
              child: _buildDayUI(date, true, onClick: () {
            _slidingKey.currentState?.closePanel();
          })));
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: listUI,
        );
      },
    );
  }

  /// 年月选择器
  Widget buildMonthYearPicker() {
    final indexDate = getDateByDeltaMonth(_pageIndex.value);
    final indexMonth = indexDate.month;
    final yearsDelta = indexDate.year + 20 - startDate.year;
    var years = List.generate(
        yearsDelta,
        (i) => Center(
              child: Text("${startDate.year + i}"),
            ));
    var months = List.generate(
        12,
        (i) => Center(
              child: Text("${i + 1}"),
            ));
    var toYear = indexDate.year;
    var toMonth = indexDate.month;
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: 50,
            onSelectedItemChanged: (val) {
              toYear = startDate.year + val;
              _pageIndex.value = getMonthDelta(DateTime(toYear, toMonth, 1));
            },
            scrollController: FixedExtentScrollController(initialItem: yearsDelta - 20),
            children: years,
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: indexMonth - 1),
            itemExtent: 50,
            onSelectedItemChanged: (val) {
              toMonth = val + 1;
              _pageIndex.value = getMonthDelta(DateTime(toYear, toMonth, 1));
            },
            children: months,
          ),
        ),
      ],
    );
  }

  /// 日期选择器
  Widget buildDatePicker() {
    return PageView.builder(
      controller: _pc,
      onPageChanged: (index) {
        _pageIndex.value = index;
      },
      itemBuilder: (BuildContext context, int index) {
        final indexDate = getDateByDeltaMonth(index);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildDaysUI(indexDate),
          ),
        );
      },
    );
  }

  /// 索引年月切换
  Widget buildYearAndMonthNavigator(int pageIndex) {
    final indexDate = getDateByDeltaMonth(pageIndex);
    var monthYear = DateFormat("MMM, yyyy").format(indexDate);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (_pickerMode != CalendarMode.date) {
            _pickerMode = CalendarMode.date;
            _pc = PageController(initialPage: pageIndex);
          } else {
            _pickerMode = CalendarMode.yearAndMonth;
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 12),
          Text(
            monthYear,
            style: const TextStyle(fontWeight: FontWeight.bold),
            strutStyle: const StrutStyle(
              height: 1,
              leading: 0.5,
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            _pickerMode == CalendarMode.date
                ? Icons.keyboard_arrow_right_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: iconColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  /// 索引月份前后切换
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
              _pc.animateToPage(pageIndex - 1,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 6, right: 8),
              child: Icon(
                Icons.arrow_back_ios,
                color: iconColor,
                size: 20,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _pc.animateToPage(pageIndex + 1,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 6),
              child: Icon(
                Icons.arrow_forward_ios,
                color: iconColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDaysUI(DateTime indexDate) {
    List<DateTime> dateList = getListOfDate(indexDate);
    final List<Widget> noList = <Widget>[];
    int count = 0;
    //dateList.length 为 42，一行是 7 列，总共是 6 行。
    for (int i = 0; i < dateList.length / 7; i++) {
      //当前行
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        bool isInMonth = indexDate.month == date.month;
        listUI.add(
          Expanded(
            child: _buildDayUI(date, isInMonth),
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

  Widget _buildDayUI(DateTime date, bool isInMonth, {VoidCallback? onClick}) {
    bool isToday = DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;
    bool isSelected = date == _selectedDate;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: <Widget>[
          // 当前行的所有日期
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                  onClick?.call();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: isSelected ? Colors.black : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                        // 当天的高亮显示
                        color: isToday
                            ? iconColor
                            : isSelected
                                ? Colors.white
                                : isInMonth
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
          //             ? themeColor
          //             : Colors.transparent,
          //         shape: BoxShape.circle),
          //   ),
          // ),
        ],
      ),
    );
  }
}
