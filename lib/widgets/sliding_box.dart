//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/11
//
import 'package:flutter/material.dart';

class SlidingBox extends StatefulWidget {
  const SlidingBox({Key? key}) : super(key: key);

  @override
  State<SlidingBox> createState() => _SlidingBoxState();
}

class _SlidingBoxState extends State<SlidingBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
