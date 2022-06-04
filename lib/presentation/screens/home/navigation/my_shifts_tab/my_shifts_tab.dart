import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../../../logic/date_selector_cubit/date_selector_cubit.dart';
import '../../../../../logic/my_shifts/cubit/my_shifts_cubit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'components/my_shift_section.dart';
import 'components/top_section.dart';

class MyShiftsTab extends StatelessWidget {
  MyShiftsTab({Key? key}) : super(key: key);

  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MyShiftsCubit(
              staff: (context.read<AuthenticationCubit>().state
                      as AuthenticationSuccess)
                  .staff!),
        ),
        BlocProvider(
          create: (context) => DateSelectorCubit(),
        )
      ],
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: _size.height,
          maxWidth: double.infinity,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 16,
            ),
            TopSection(
              calendarController: _controller,
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: MyShiftsSection(
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
