import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/pip_params.dart';

class MovableOverlay extends StatefulWidget {
  final PIPViewCorner initialCorner;

  final PiPParams pipParams;
  final bool avoidKeyboard;
  final Widget? topWidget;
  final Widget? bottomWidget;

  // this is exposed because trying to watch onTap event
  // by wrapping the top widget with a gesture detector
  // causes the tap to be lost sometimes because it
  // is competing with the drag
  final void Function()? onTapTopWidget;

  const MovableOverlay({
    Key? key,
    this.initialCorner = PIPViewCorner.topRight,
    this.avoidKeyboard = true,
    this.topWidget,
    this.bottomWidget,
    this.onTapTopWidget,
    this.pipParams = const PiPParams(),
  }) : super(key: key);

  @override
  MovableOverlayState createState() => MovableOverlayState();
}

class MovableOverlayState extends State<MovableOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _toggleFloatingAnimationController;
  late final AnimationController _dragAnimationController;
  late PIPViewCorner _corner;
  Offset _dragOffset = Offset.zero;
  var _isDragging = false;
  var _isFloating = false;
  Widget? _bottomWidgetGhost;
  Map<PIPViewCorner, Offset> _offsets = {};
  final defaultAnimationDuration = const Duration(milliseconds: 200);
  Widget? bottomChild;

  @override
  void initState() {
    super.initState();
    _corner = widget.initialCorner;
    _toggleFloatingAnimationController = AnimationController(
      duration: defaultAnimationDuration,
      vsync: this,
    );
    _dragAnimationController = AnimationController(
      duration: defaultAnimationDuration,
      vsync: this,
    );
    bottomChild = widget.bottomWidget;
  }

  @override
  void didUpdateWidget(covariant MovableOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isFloating) {
      if (widget.topWidget == null || bottomChild == null) {
        _isFloating = false;
        _bottomWidgetGhost = oldWidget.bottomWidget;
        _toggleFloatingAnimationController.reverse().whenCompleteOrCancel(() {
          if (mounted) {
            setState(() => _bottomWidgetGhost = null);
          }
        });
      }
    } else {
      if (widget.topWidget != null && bottomChild != null) {
        _isFloating = true;
        _toggleFloatingAnimationController.forward();
      }
    }
  }

  void _updateCornersOffsets({
    required Size spaceSize,
    required Size widgetSize,
    required EdgeInsets windowPadding,
  }) {
    _offsets = _calculateOffsets(
      spaceSize: spaceSize,
      widgetSize: widgetSize,
      windowPadding: windowPadding,
    );
  }

  bool _isAnimating() {
    return _toggleFloatingAnimationController.isAnimating ||
        _dragAnimationController.isAnimating;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    setState(() {
      _dragOffset = _dragOffset.translate(
        details.delta.dx,
        details.delta.dy,
      );
    });
  }

  void _onPanCancel() {
    if (!_isDragging) return;
    setState(() {
      _dragAnimationController.value = 0;
      _dragOffset = Offset.zero;
      _isDragging = false;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    final nearestCorner = _calculateNearestCorner(
      offset: _dragOffset,
      offsets: _offsets,
    );
    setState(() {
      _corner = nearestCorner;
      _isDragging = false;
    });
    _dragAnimationController.forward().whenCompleteOrCancel(() {
      _dragAnimationController.value = 0;
      _dragOffset = Offset.zero;
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (_isAnimating()) return;
    setState(() {
      _dragOffset = _offsets[_corner]!;
      _isDragging = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var windowPadding = mediaQuery.padding;
    if (widget.avoidKeyboard) {
      windowPadding += mediaQuery.viewInsets;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bottomWidget = bottomChild ?? _bottomWidgetGhost;
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        double? floatingWidth =
            widget.topWidget != null ? widget.pipParams.pipWindowWidth : 0;
        double? floatingHeight =
            widget.topWidget != null ? widget.pipParams.pipWindowHeight : 0;

        final floatingWidgetSize = Size(floatingWidth, floatingHeight);
        final fullWidgetSize = Size(width, height);

        _updateCornersOffsets(
          spaceSize: fullWidgetSize,
          widgetSize: floatingWidgetSize,
          windowPadding: windowPadding,
        );

        final calculatedOffset = _offsets[_corner];

        return Stack(
          children: <Widget>[
            if (bottomWidget != null) Center(child: bottomWidget),
            if (widget.topWidget != null)
              AnimatedBuilder(
                animation: Listenable.merge([
                  _toggleFloatingAnimationController,
                  _dragAnimationController,
                ]),
                builder: (context, child) {
                  final animationCurve = CurveTween(
                    curve: Curves.easeInOutQuad,
                  );
                  final dragAnimationValue = animationCurve.transform(
                    _dragAnimationController.value,
                  );
                  final toggleFloatingAnimationValue = animationCurve.transform(
                    _toggleFloatingAnimationController.value,
                  );

                  final floatingOffset = _isDragging
                      ? _dragOffset
                      : Tween<Offset>(
                          begin: _dragOffset,
                          end: calculatedOffset,
                        ).transform(_dragAnimationController.isAnimating
                          ? dragAnimationValue
                          : toggleFloatingAnimationValue);
                  final width = Tween<double>(
                    begin: fullWidgetSize.width,
                    end: floatingWidgetSize.width,
                  ).transform(toggleFloatingAnimationValue);
                  final height = Tween<double>(
                    begin: fullWidgetSize.height,
                    end: floatingWidgetSize.height,
                  ).transform(toggleFloatingAnimationValue);

                  return Positioned(
                    left: floatingOffset.dx,
                    top: floatingOffset.dy,
                    child: GestureDetector(
                      onPanStart: _isFloating ? _onPanStart : null,
                      onPanUpdate: _isFloating ? _onPanUpdate : null,
                      onPanCancel: _isFloating ? _onPanCancel : null,
                      onPanEnd: _isFloating ? _onPanEnd : null,
                      onTap: widget.onTapTopWidget,
                      child: SizedBox(
                        width: width,
                        height: height,
                        child: child,
                      ),
                    ),
                  );
                },
                child: widget.topWidget,
              ),
          ],
        );
      },
    );
  }

  Map<PIPViewCorner, Offset> _calculateOffsets({
    required Size spaceSize,
    required Size widgetSize,
    required EdgeInsets windowPadding,
  }) {
    Offset getOffsetForCorner(PIPViewCorner corner) {
      final left = widget.pipParams.leftSpace + windowPadding.left;
      final top = widget.pipParams.topSpace + windowPadding.top;
      final right = spaceSize.width -
          widgetSize.width -
          windowPadding.right -
          widget.pipParams.rightSpace;
      final bottom = spaceSize.height -
          widgetSize.height -
          windowPadding.bottom -
          widget.pipParams.bottomSpace;

      switch (corner) {
        case PIPViewCorner.topLeft:
          return Offset(left, top);
        case PIPViewCorner.topRight:
          return Offset(right, top);
        case PIPViewCorner.bottomLeft:
          return Offset(left, bottom);
        case PIPViewCorner.bottomRight:
          return Offset(right, bottom);
        default:
          throw UnimplementedError();
      }
    }

    const corners = PIPViewCorner.values;
    final Map<PIPViewCorner, Offset> offsets = {};
    for (final corner in corners) {
      offsets[corner] = getOffsetForCorner(corner);
    }

    return offsets;
  }
}

enum PIPViewCorner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class _CornerDistance {
  final PIPViewCorner corner;
  final double distance;

  _CornerDistance({
    required this.corner,
    required this.distance,
  });
}

PIPViewCorner _calculateNearestCorner({
  required Offset offset,
  required Map<PIPViewCorner, Offset> offsets,
}) {
  _CornerDistance calculateDistance(PIPViewCorner corner) {
    final distance = offsets[corner]!
        .translate(
          -offset.dx,
          -offset.dy,
        )
        .distanceSquared;
    return _CornerDistance(
      corner: corner,
      distance: distance,
    );
  }

  final distances = PIPViewCorner.values.map(calculateDistance).toList();

  distances.sort((cd0, cd1) => cd0.distance.compareTo(cd1.distance));

  return distances.first.corner;
}
