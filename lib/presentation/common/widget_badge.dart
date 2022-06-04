import 'package:flutter/material.dart';
import 'badge.dart';

class WidgetBadge extends StatelessWidget {
  final Widget child;
  final String? text;
  final double? cornerRadius;
  const WidgetBadge({
    Key? key,
    required this.child,
    this.text,
    this.cornerRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 5, child: child),
        if (text != null && text != "0")
          Positioned(
            right: 0,
            child: Badge(
              count: text,
              cornerRadius: cornerRadius,
            ),
          )
      ],
    );
  }
}
