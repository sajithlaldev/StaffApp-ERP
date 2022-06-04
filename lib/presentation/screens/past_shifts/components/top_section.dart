import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/past_shifts/cubit/past_shifts_cubit.dart';
import '../../../../logic/tabs/tabs_cubit.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/utils.dart';

import '../../../../logic/date_range_selector_cubit/date_range_selector_cubit.dart';
import '../../../../utils/strings.dart';
import '../../../common/capsule.dart';

class TopSection extends StatelessWidget {
  const TopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TabsCubit, TabState>(
      listener: (context, state) {
        print("I am rningng");
        BlocProvider.of<PastShiftsCubit>(context).loadShifts(
            status: state.currentIndex == 0 ? "completed" : "cancelled",
            filters: [
              {
                "name": "from",
                "value": (context.read<DateRangeSelectorCubit>().state
                        as DateRangeSelectorLoaded)
                    .fromDate
                    .toString(),
              },
              {
                "name": "till",
                "value": (context.read<DateRangeSelectorCubit>().state
                        as DateRangeSelectorLoaded)
                    .tillDate
                    .toString(),
              }
            ]);
      },
      builder: (context, state) {
        return Column(
          children: [
            const DateRangeFilter(),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          BlocProvider.of<TabsCubit>(context).onTabSwitch(0),
                      child: CapsuleWidget(
                        title: Strings.COMPLETED,
                        isActive: state.currentIndex == 0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          BlocProvider.of<TabsCubit>(context).onTabSwitch(1),
                      child: CapsuleWidget(
                        title: Strings.CANCELLED,
                        isActive: state.currentIndex == 1,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class DateRangeFilter extends StatelessWidget {
  const DateRangeFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var res = await showDateRangePicker(
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                primaryColor: AppColors.primary,
                accentColor: AppColors.primary,
                primaryTextTheme: const TextTheme(
                    bodySmall: TextStyle(
                  color: Colors.white,
                )),
                colorScheme: const ColorScheme.light().copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white, // header text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.white, // button text color
                  ),
                ),
                scaffoldBackgroundColor: Colors.white,
                // applyElevationOverlayColor: true,
              ),
              child: child!,
            );
          },
          context: context,
          firstDate: DateTime(2022),
          lastDate: DateTime.now(),
          initialEntryMode: DatePickerEntryMode.calendarOnly,
        );
        if (res != null) {
          BlocProvider.of<DateRangeSelectorCubit>(context).setDates(
            res.start,
            res.end,
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<DateRangeSelectorCubit, DateRangeSelectorState>(
            builder: (context, state) {
              if (state is DateRangeSelectorLoaded) {
                return Text(
                  Utils.formatDateOnlyInReadFormat(state.fromDate.toString()) +
                      " - " +
                      Utils.formatDateOnlyInReadFormat(
                          state.tillDate.toString()),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 12,
                      ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(
            width: 10,
          ),
          Image.asset(
            Assets.MY_SHIFTS,
            color: AppColors.primary,
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
