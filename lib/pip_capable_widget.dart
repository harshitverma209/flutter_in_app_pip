import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';

class PiPCapableWidget extends StatefulWidget {
  final Widget whileNotInPip;
  final Widget? whileInPip;

  const PiPCapableWidget(
      {super.key, this.whileInPip, required this.whileNotInPip});

  @override
  State<PiPCapableWidget> createState() => _PiPCapableWidgetState();
}

class _PiPCapableWidgetState extends State<PiPCapableWidget> {
  Widget _defaultWhileInPiPWidget() {
    return Builder(builder: (context) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: const Text(
            'Playing in PiP',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  late Widget whileInPip;

  @override
  void initState() {
    whileInPip = widget.whileInPip ?? _defaultWhileInPiPWidget();
    if (PictureInPicture.isActive) {
      PictureInPicture.stopPiP();
      PictureInPicture.isActive = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PictureInPicture.isActive ? whileInPip : widget.whileNotInPip,
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
