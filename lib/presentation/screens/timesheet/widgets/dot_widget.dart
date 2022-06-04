import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class DotWidget extends StatelessWidget {
  final bool isSelected;
  const DotWidget({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : AppColors.iconColor,
      ),
    );
  }
}
