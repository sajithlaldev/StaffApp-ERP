import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class BadgeIcon extends StatelessWidget {
  final String icon;
  final String? text;
  const BadgeIcon({
    Key? key,
    required this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        children: [
          Positioned(top: 5, child: Image.asset(icon)),
          text != null
              ? Positioned(
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        text!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
