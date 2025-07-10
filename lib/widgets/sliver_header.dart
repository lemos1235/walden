//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/1/11
//
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPinnedHeader extends SingleChildRenderObjectWidget {
  const SliverPinnedHeader({super.key, required Widget child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverPinnedHeader();
  }
}

class RenderSliverPinnedHeader extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    // 1.对子节点进行约束 SliverConstraints
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    final paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);

    final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    print('constraints.overlap: ${constraints.overlap}');

    final paintExtent = math.min(childExtent, constraints.remainingPaintExtent - constraints.overlap);

    // 2.上报当前节点的布局信息给 viewport
    geometry = SliverGeometry(
      // visible: paintExtent > 0.0
      //解决问题的关键是这个：将 origin 设置为被覆盖的高度
      paintOrigin: constraints.overlap,
      scrollExtent: childExtent,
      paintExtent: paintExtent,
      layoutExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      final SliverPhysicalParentData childParentData = child!.parentData! as SliverPhysicalParentData;
      // 4.绘制子节点
      // topOffset = constraints.viewportMainAxisExtent - constraints.remainingPaintExtent;
      //其中 offset = topOffset(sliver 到达顶部后等于 0） + paintOrigin(默认等于0）
      //其中 paintOffset(默认等于0)
      //即到达顶部后，如果两者都等于0，并且 visible 不等于 false，则 child 保持当前位置不变。
      context.paintChild(child!, offset + childParentData.paintOffset);
    }
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    return 0;
  }
}
