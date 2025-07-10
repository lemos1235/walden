//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/11
//
import 'package:flutter/material.dart';

const double kIndicatorHeight = 26.0;

const double kFlingSpeed = 365.0;

const double kSlidingDefaultMaxHeight = 200.0;

typedef SlidingBodyBuilder = Widget Function(BuildContext context, AnimationController controller);

class SlidingPanel extends StatefulWidget {
  const SlidingPanel(
      {Key? key, this.maxHeight = kSlidingDefaultMaxHeight, this.minHeight = 0, required this.builder})
      : super(key: key);

  final SlidingBodyBuilder builder;

  final double maxHeight;

  final double minHeight;

  final double indicatorHeight = kIndicatorHeight;

  final double flingSpeed = kFlingSpeed;

  @override
  State<SlidingPanel> createState() => SlidingPanelState();
}

class SlidingPanelState extends State<SlidingPanel> with SingleTickerProviderStateMixin {
  late AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  void openPanel() {
    _ac.animateTo(1.0, duration: const Duration(milliseconds: 300));
  }

  void closePanel() {
    _ac.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _onGestureSlide(details.delta.dy);
      },
      onPanEnd: (details) {
        _onGestureEnd(details.velocity);
      },
      child: AnimatedBuilder(
        animation: _ac,
        builder: (BuildContext context, Widget? child) {
          final currHeight = (widget.maxHeight - widget.minHeight) * _ac.value + widget.minHeight;
          final deltaY = -(widget.maxHeight - currHeight) / 2;
          return SizedBox(
            height: currHeight + widget.indicatorHeight,
            child: Stack(
              children: [
                Positioned(
                  top: deltaY,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _ac.value,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: widget.maxHeight),
                      child: widget.builder(context, _ac),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: child!,
                ),
              ],
            ),
          );
        },
        child: _buildSlideIndicator(),
      ),
    );
  }

  void _onGestureSlide(double dy) {
    //向下滚动 dy > 0; 向上滚动 dy < 0
    print('slide: $dy');
    _ac.value += dy / (widget.maxHeight - widget.minHeight);
  }

  void _onGestureEnd(Velocity v) {
    print('onGestureEnd: ${v.pixelsPerSecond.dy}');

    //如果动画已经运行，则直接返回
    if (_ac.isAnimating) return;

    double visualVelocity = v.pixelsPerSecond.dy / (widget.maxHeight - widget.minHeight);
    print('pixelsPerSecond: ${v.pixelsPerSecond.dy}, visualVelocity: $visualVelocity');
    //若当前下拉速度超过阈值，则进行 fling
    if (v.pixelsPerSecond.dy.abs() >= widget.flingSpeed) {
      //velocity 等于 -1 是关闭，1 是打开
      //fling，按一秒的时间计算滑过的距离
      _ac.fling(velocity: visualVelocity);
      return;
    }
    // 若当前下拉速度未超过阈值
    if (_ac.value >= 0.5) {
      _ac.fling(velocity: 1);
    } else {
      _ac.fling(velocity: -1);
    }
  }

  Widget _buildSlideIndicator() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _ac.value == 0 ? openPanel() : closePanel();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
