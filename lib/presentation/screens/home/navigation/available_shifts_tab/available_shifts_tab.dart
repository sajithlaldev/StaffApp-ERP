import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../logic/available_shifts/cubit/available_shifts_cubit.dart';
import '../../../../../logic/date_selector_cubit/date_selector_cubit.dart';
import 'components/available_shift_section.dart';

class AvailableShiftsTab extends StatelessWidget {
  const AvailableShiftsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AvailableShiftsCubit(),
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
          children: const [
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: AvailableShiftSection(),
            ),
          ],
        ),
      ),
    );
  }
}
