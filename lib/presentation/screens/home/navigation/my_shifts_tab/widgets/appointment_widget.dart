import 'package:flutter/material.dart';
import '../../../../../../utils/assets.dart';
import '../../../../../../utils/colors.dart';
import '../../../../../../data/models/shift_calendar.dart';

class ShiftCalenderWidget extends StatelessWidget {
  final ShiftCalendarModel shiftCalendarModel;
  const ShiftCalenderWidget({
    Key? key,
    required this.shiftCalendarModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = shiftCalendarModel.status == "confirmed"
        ? AppColors.primary
        : shiftCalendarModel.status == "completed"
            ? AppColors.calendarCompletedShiftColor
            : AppColors.calendarCancelledShiftColor;

    return Container(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(
          top: 4,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.3,
          ),
          color: color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 8,
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shiftCalendarModel.provider.isNotEmpty
                        ? Row(
                            children: [
                              Image.asset(
                                Assets.PROVIDERS,
                                width: 12,
                                height: 12,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                shiftCalendarModel.provider,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          Assets.USER,
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          shiftCalendarModel.customer,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          Assets.LOCATION,
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          shiftCalendarModel.address,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
