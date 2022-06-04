import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../../../../logic/my_shifts/cubit/my_shifts_cubit.dart';
import '../../../../../../utils/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../../logic/calendar/calendar_cubit.dart';
import '../../../../../../logic/date_selector_cubit/date_selector_cubit.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../common/week_view.dart';
import '../widgets/calendart.dart';

class TopSection extends StatelessWidget {
  final CalendarController calendarController;

  const TopSection({Key? key, required this.calendarController})
      : super(key: key);

  showCalender(ctx) async {
    DateTime selectedDate = BlocProvider.of<DateSelectorCubit>(ctx).state
            is DateSelectorLoaded
        ? (BlocProvider.of<DateSelectorCubit>(ctx).state as DateSelectorLoaded)
            .date
        : DateTime.now();
    DateTime? date = await showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (_) {
        return BlocProvider<CalendarCubit>(
          create: (context) => CalendarCubit(selectedDate),
          child: Calendar(
            date: selectedDate,
          ),
        );
      },
    );
    if (date != null) {
      print("SELECTED DATE: " + date.toString());
      BlocProvider.of<DateSelectorCubit>(ctx).setDate(date);
      calendarController.displayDate = date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
                left: 16,
              ),
              child: GestureDetector(
                onTap: () {
                  showCalender(context);
                },
                child: BlocBuilder<DateSelectorCubit, DateSelectorState>(
                  builder: (context, state) {
                    final selectedDate = state is DateSelectorLoaded
                        ? state.date
                        : DateTime.now();
                    BlocProvider.of<MyShiftsCubit>(context).loadShifts(
                      date: selectedDate.toString(),
                      staff: (context.read<AuthenticationCubit>().state
                              as AuthenticationSuccess)
                          .staff!,
                    );
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  selectedDate != null
                                      ? '${Utils.getMonth(selectedDate.month)}'
                                      : '',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  selectedDate != null
                                      ? '${selectedDate.day}'
                                      : '',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            border: Border.all(
                              color: AppColors.lightAccent,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: BlocBuilder<MyShiftsCubit, MyShiftsState>(
                            builder: (context, state) {
                              return Text(
                                state is MyShiftsLoaded
                                    ? 'You have ${state.shifts.length} shifts in total'
                                    : 'You have shifts in total', //dynamic content
                                style: Theme.of(context).textTheme.bodyText1,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<DateSelectorCubit, DateSelectorState>(
          builder: (context, state) {
            return SizedBox(
              width: width,
              height: 50,
              child: state is DateSelectorLoaded
                  ? WeekView(
                      weekNumber: (context.read<DateSelectorCubit>().state
                              as DateSelectorLoaded)
                          .date
                          .weekday,
                      onTap: (int weekNumber) {
                        int currentWeekDay = (context
                                .read<DateSelectorCubit>()
                                .state as DateSelectorLoaded)
                            .date
                            .weekday;
                        if (weekNumber > currentWeekDay) {
                          final date = (context.read<DateSelectorCubit>().state
                                  as DateSelectorLoaded)
                              .date
                              .add(
                                Duration(
                                  days: weekNumber - currentWeekDay,
                                ),
                              );
                          BlocProvider.of<DateSelectorCubit>(context).setDate(
                            date,
                          );
                          calendarController.displayDate = date;
                        } else if (weekNumber < currentWeekDay) {
                          final date = (context.read<DateSelectorCubit>().state
                                  as DateSelectorLoaded)
                              .date
                              .subtract(
                                Duration(
                                  days: currentWeekDay - weekNumber,
                                ),
                              );
                          BlocProvider.of<DateSelectorCubit>(context)
                              .setDate(date);
                          calendarController.displayDate = date;
                        }
                      },
                      arrowLeftFunction: () {
                        final date = (context.read<DateSelectorCubit>().state
                                as DateSelectorLoaded)
                            .date
                            .subtract(
                              const Duration(
                                days: 1,
                              ),
                            );
                        BlocProvider.of<DateSelectorCubit>(context)
                            .setDate(date);
                        calendarController.displayDate = date;
                      },
                      arrowRightFunction: () {
                        final date = (context.read<DateSelectorCubit>().state
                                as DateSelectorLoaded)
                            .date
                            .add(
                              const Duration(
                                days: 1,
                              ),
                            );
                        BlocProvider.of<DateSelectorCubit>(context)
                            .setDate(date);
                        calendarController.displayDate = date;
                      },
                    )
                  : const SizedBox(),
            );
          },
        )
      ],
    );
  }
}
