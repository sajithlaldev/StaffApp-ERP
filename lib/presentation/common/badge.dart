import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class Badge extends StatelessWidget {
  final String? count;
  final double? cornerRadius;

  const Badge({
    Key? key,
    required this.count,
    this.cornerRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(cornerRadius ?? 4),
      ),
      child: count != null
          ? Center(
              child: Text(
                count!,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
