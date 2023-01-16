import 'package:flutter/material.dart';
import 'package:walden/widgets/size_reporting.dart';

typedef TestSizeBuilder = Widget Function(BuildContext context, Widget child, Size childSize);

class TestSizeWidget extends StatefulWidget {
  const TestSizeWidget({Key? key, required this.child, required this.builder, this.useScreenSize = false})
      : super(key: key);

  final Widget child;

  final TestSizeBuilder builder;

  final bool useScreenSize;

  @override
  State<TestSizeWidget> createState() => _TestSizeWidgetState();
}

class _TestSizeWidgetState extends State<TestSizeWidget> {
  Size? _childSize;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (_childSize != null) {
      return widget.builder(context, widget.child, _childSize!);
    }
    final sizedReporting = SizeReportingWidget(
      onSizeChange: (Size childSize) {
        setState(() {
          _childSize = childSize;
        });
      },
      child: widget.child,
    );
    if (widget.useScreenSize) {
      return OverflowBox(
        maxHeight: screenSize.height,
        maxWidth: screenSize.width,
        minHeight: 0,
        minWidth: 0,
        child: sizedReporting,
      );
    } else {
      return sizedReporting;
    }
  }
}

typedef TestSizeItemBuilderBuilder = Widget Function(
    BuildContext context, IndexedWidgetBuilder itemBuilder, Size itemSize);

class TestSizeItemBuilderWidget extends StatefulWidget {
  const TestSizeItemBuilderWidget(
      {Key? key, required this.builder, required this.itemBuilder, this.itemInitialIndex = 0})
      : super(key: key);

  final TestSizeItemBuilderBuilder builder;

  final IndexedWidgetBuilder itemBuilder;

  final int itemInitialIndex;

  @override
  State<TestSizeItemBuilderWidget> createState() => _TestSizeItemBuilderWidgetState();
}

class _TestSizeItemBuilderWidgetState extends State<TestSizeItemBuilderWidget> {
  Size? _childSize;

  @override
  Widget build(BuildContext context) {
    return _childSize == null
        ? SizeReportingWidget(
            child: widget.itemBuilder(context, widget.itemInitialIndex),
            onSizeChange: (Size childSize) {
              setState(() {
                _childSize = childSize;
              });
            })
        : widget.builder(context, widget.itemBuilder, _childSize!);
  }
}
