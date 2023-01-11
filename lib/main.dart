import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walden/pages/goal_page.dart';
import 'package:walden/pages/home_page.dart';
import 'package:walden/pages/note_page.dart';
import 'package:walden/pages/task_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            iconTheme: IconThemeData(
              color: Colors.black87,
            ),
            toolbarTextStyle: TextStyle(
              color: Colors.black,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black87,
            selectedLabelStyle: TextStyle(fontSize: 12),
          )),
      home: const NavigatorHomeScreen(),
    );
  }
}

class NavigatorHomeScreen extends StatefulWidget {
  const NavigatorHomeScreen({super.key});

  @override
  State<NavigatorHomeScreen> createState() => _NavigatorHomeScreenState();
}

class _NavigatorHomeScreenState extends State<NavigatorHomeScreen> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomePage(),
          TaskPage(),
          GoalPage(),
          NotePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "日历"),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: "任务"),
          BottomNavigationBarItem(icon: Icon(Icons.percent), label: "目标进度"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "笔记"),
        ],
      ),
    );
  }
}
