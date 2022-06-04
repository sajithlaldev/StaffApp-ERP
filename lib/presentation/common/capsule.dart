import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/styles.dart';

class CapsuleWidget extends StatelessWidget {
  final String title;
  final bool isActive;

  const CapsuleWidget({
    Key? key,
    required this.title,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: Styles.boxDecoration(
        isActive,
        color: Colors.transparent,
        cornerRadius: 20,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color:
                      isActive ? AppColors.primary : AppColors.unSelectedColor,
                ),
          ),
        ),
      ),
    );
  }
}
