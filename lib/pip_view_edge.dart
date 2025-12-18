import 'package:flutter/widgets.dart';

enum PIPViewEdge {
  top,
  left,
  bottom,
  right;

  (double, double) distanceAndPosition(
      {required Size widgetSize,
      required Size windowSize,
      required Offset offset}) {
    switch (this) {
      case PIPViewEdge.top:
        return (offset.dy, offset.dx);
      case PIPViewEdge.left:
        return (offset.dx, offset.dy);
      case PIPViewEdge.bottom:
        return (windowSize.height - widgetSize.height - offset.dy, offset.dx);
      case PIPViewEdge.right:
        return (windowSize.width - widgetSize.width - offset.dx, offset.dy);
    }
  }

  Offset offsetForPosition(
      {required double position,
      required EdgeInsets padding,
      required Size widgetSize,
      required Size windowSize}) {
    final limitedXPosition = position.clamp(
        padding.left, windowSize.width - widgetSize.width - padding.right);
    final limitedYPosition = position.clamp(
        padding.top, windowSize.height - widgetSize.height - padding.bottom);
    switch (this) {
      case PIPViewEdge.top:
        return Offset(limitedXPosition, padding.top);
      case PIPViewEdge.left:
        return Offset(padding.left, limitedYPosition);
      case PIPViewEdge.bottom:
        return Offset(limitedXPosition,
            windowSize.height - widgetSize.height - padding.bottom);
      case PIPViewEdge.right:
        return Offset(windowSize.width - widgetSize.width - padding.right,
            limitedYPosition);
    }
  }
}
