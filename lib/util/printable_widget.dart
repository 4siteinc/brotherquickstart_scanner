import 'package:flutter/material.dart';

class PrintableWidget extends StatefulWidget {
  final Function(GlobalKey key) builder;

  const PrintableWidget({
    required this.builder,
    required Key key,
  }) : super(key: key);

  @override
  _PrintableWidgetState createState() => _PrintableWidgetState();
}

class _PrintableWidgetState extends State<PrintableWidget> {
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}
