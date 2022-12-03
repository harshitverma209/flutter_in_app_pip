import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';

class PiPWidget extends StatefulWidget {
  final Widget child;
  final Function onPiPClose;
  final double elevation;
  final double pipBorderRadius;

  static void closePiP() {
    PictureInPicture.stopPiP();
  }

  const PiPWidget({
    Key? key,
    required this.onPiPClose,
    this.pipBorderRadius = 5,
    this.elevation = 10,
    required this.child,
  }) : super(key: key);

  @override
  State<PiPWidget> createState() => _PiPWidgetState();
}

class _PiPWidgetState extends State<PiPWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(widget.pipBorderRadius),
      elevation: widget.elevation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.onPiPClose();
    super.dispose();
  }
}
