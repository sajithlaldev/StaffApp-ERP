import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../logic/date_range_selector_cubit/date_range_selector_cubit.dart';
import '../../../logic/past_shifts/cubit/past_shifts_cubit.dart';
import '../../../logic/tabs/tabs_cubit.dart';
import 'components/past_shifts_section.dart';
import '../../../utils/colors.dart';
import 'components/appbar.dart';
import 'components/top_section.dart';

class PastShiftsScreen extends StatelessWidget {
  const PastShiftsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PastShiftsCubit(
            staff: (context.read<AuthenticationCubit>().state
                    as AuthenticationSuccess)
                .staff!,
          ),
        ),
        BlocProvider(
          create: (context) => TabsCubit(),
        ),
        BlocProvider(
          create: (context) => DateRangeSelectorCubit(),
        )
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
        ),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: AppBarWidget(),
          ),
          backgroundColor: AppColors.accent,
          body: SafeArea(
            child: Column(
              children: const [
                TopSection(),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: PastShiftsSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
