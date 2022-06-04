import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/strings.dart';

import '../../../../logic/calendar/calendar_cubit.dart';
import '../../../../logic/date_selector_cubit/date_selector_cubit.dart';
import '../../past_shifts/widgets/calendart.dart';

class AppBarWidget extends StatelessWidget {
  AppBarWidget({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

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
      BlocProvider.of<DateSelectorCubit>(ctx).setDate(date);
      // BlocProvider.of<AvailableRidesCubit>(ctx).loadAvailableRides(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: AppColors.bottomNavIconColor,
                size: 38,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                Strings.TIMESHEET,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontSize: 24,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
