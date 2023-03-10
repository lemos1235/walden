import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:walden/goal/goal_page.dart';
import 'package:walden/home/home_page.dart';
import 'package:walden/note/note_page.dart';
import 'package:walden/task/task_page.dart';

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
    Intl.defaultLocale = "zh";
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: CupertinoScrollBehavior(),
      theme: ThemeData(
          primarySwatch: Colors.orange,
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('zh', 'CN'),
      ],
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
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "??????"),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: "??????"),
          BottomNavigationBarItem(icon: Icon(Icons.percent), label: "????????????"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "??????"),
        ],
      ),
    );
  }
}
