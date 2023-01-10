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
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("HomePage"));
  }
}
