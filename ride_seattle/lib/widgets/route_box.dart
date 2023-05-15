import 'package:flutter/material.dart';

class RouteBox extends StatefulWidget {
  final String text;
  const RouteBox({super.key, required this.text, required this.maxW});
  final double maxW;

  @override
  State<RouteBox> createState() => _RouteBoxState();
}

class _RouteBoxState extends State<RouteBox> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        key: const ValueKey("route_box"),
        constraints: BoxConstraints(
          maxHeight: 40,
          minWidth: 40,
          maxWidth: widget.maxW,
        ),
        
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
          child: Tooltip(
            message: widget.text,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.text,
                style: Theme.of(context).primaryTextTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
