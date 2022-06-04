import 'package:flutter/material.dart';
import 'package:hiftapp/utils/colors.dart';
import 'package:hiftapp/utils/constants.dart';
import 'package:hiftapp/utils/styles.dart';

class WeekView extends StatelessWidget {
  final int weekNumber;
  final Function arrowLeftFunction;
  final Function arrowRightFunction;
  final Function(int) onTap;
  const WeekView({
    Key? key,
    required this.weekNumber,
    required this.arrowLeftFunction,
    required this.arrowRightFunction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent,
        boxShadow: [
          Styles.boxShadow,
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => arrowLeftFunction(),
              child: const Center(
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
            ),
          ),
          ListView.builder(
            itemCount: Constants.weeks2.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var isSelected = index + 1 == weekNumber;
              return InkWell(
                onTap: () => onTap(index + 1),
                child: Container(
                  width: 30,
                  padding: const EdgeInsets.all(
                    6,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(
                      4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      Constants.weeks2[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () => arrowRightFunction(),
              child: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
