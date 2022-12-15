import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';

class NavigatablePiPWidget extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final Function onPiPClose;
  final double elevation;
  final double pipBorderRadius;

  static void closePiP() {
    PictureInPicture.stopPiP();
  }

  const NavigatablePiPWidget({
    Key? key,
    required this.onPiPClose,
    this.pipBorderRadius = 5,
    this.elevation = 10,
    required this.builder,
  }) : super(key: key);

  @override
  State<NavigatablePiPWidget> createState() => _NavigatablePiPWidgetState();
}

class _NavigatablePiPWidgetState extends State<NavigatablePiPWidget> {
  @override
  Widget build(BuildContext context) {
    return HeroControllerScope.none(
      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return PiPWidget(
                onPiPClose: widget.onPiPClose,
                pipBorderRadius: widget.pipBorderRadius,
                elevation: widget.elevation,
                child: widget.builder(context),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
