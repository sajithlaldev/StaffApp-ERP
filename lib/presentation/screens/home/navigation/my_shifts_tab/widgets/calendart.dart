import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../utils/colors.dart';

import '../../../../../../logic/calendar/calendar_cubit.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/utils.dart';

class Calendar extends StatelessWidget {
  final DateTime? date;

  const Calendar({Key? key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    String empty = '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height * 0.11,
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.05),
          height: 360,
          width: width * 0.7,
          decoration: BoxDecoration(
            color: AppColors.accent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10.0,
              )
            ],
          ),
          child: BlocBuilder<CalendarCubit, CalendarState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (state is CalendarLoaded) {
                            int year = state.date.year - 1;
                            BlocProvider.of<CalendarCubit>(context)
                                .changeDate(state.date, year: year);
                          }
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_left,
                          color: AppColors.bottomNavIconColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        state is CalendarLoaded ? '${state.date.year}' : '',
                        style: const TextStyle(
                          color: AppColors.bottomNavIconColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (state is CalendarLoaded) {
                            int year = state.date.year + 1;
                            BlocProvider.of<CalendarCubit>(context)
                                .changeDate(state.date, year: year);
                          }
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.bottomNavIconColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (state is CalendarLoaded) {
                            int month = (state.date.month - 1) % 12;
                            BlocProvider.of<CalendarCubit>(context)
                                .changeDate(state.date, month: month);
                          }
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_left,
                          color: AppColors.bottomNavIconColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        state is CalendarLoaded
                            ? '${Utils.getMonth(state.date.month)}'
                            : '',
                        style: const TextStyle(
                          color: AppColors.bottomNavIconColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (state is CalendarLoaded) {
                            int month = (state.date.month + 1) % 12;
                            BlocProvider.of<CalendarCubit>(context)
                                .changeDate(state.date, month: month);
                          }
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.bottomNavIconColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 40,
                    width: width * .7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: Constants.weeks
                            .map(
                              (e) => Text(
                                '$e',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                    ),
                    child: BlocBuilder<CalendarCubit, CalendarState>(
                      builder: (context, state) {
                        if (state is CalendarLoaded) {
                          return SizedBox(
                            height: 220,
                            width: width * 0.8,
                            child: GridView.builder(
                              itemCount: Utils.getDaysInMonth(
                                state.date.year,
                                state.date.month,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: 7,
                              ),
                              itemBuilder: (ctx, index) {
                                int finalIndex = (index -
                                    DateTime.utc(
                                      state.date.year,
                                      state.date.month,
                                      1,
                                    ).weekday +
                                    1);
                                return GestureDetector(
                                  onTap: () {
                                    if (finalIndex > 0) {
                                      Navigator.pop(
                                        context,
                                        DateTime.utc(
                                          state.date.year,
                                          state.date.month,
                                          finalIndex,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    '${finalIndex > 0 ? finalIndex : empty}',
                                    style: TextStyle(
                                      color: finalIndex > 0 &&
                                              state.date.day == finalIndex
                                          ? AppColors.primary
                                          : Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is CalendarLoading) {
                          return const CircularProgressIndicator();
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
