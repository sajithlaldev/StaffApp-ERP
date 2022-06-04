import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../../../../logic/available_shifts/cubit/available_shifts_cubit.dart';
import '../../../../../common/circular_progress.dart';
import '../widgets/shift_list_item.dart';
import '../../../../../../utils/colors.dart';
import '../../../../../../utils/routes.dart';
import '../../../../../../utils/strings.dart';

import '../../../../../../utils/utils.dart';

class AvailableShiftSection extends StatelessWidget {
  const AvailableShiftSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
          return BlocConsumer<AvailableShiftsCubit, AvailableShiftsState>(
            listener: (context, state) {
              if (state is AvailableShiftsFailure) {
                String error = state.message.split("\n")[0];
                if (error.contains("firebase")) {
                  int start = error.indexOf("[");
                  int end = error.indexOf("]");
                  error.replaceRange(start, end, "");
                }

                Utils.showSnackBar(context, error);
              }
            },
            builder: (context, state) {
              if (state is AvailableShiftsLoaded) {
                if (state.shifts.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.shifts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/confirmation',
                          arguments: state.shifts[index],
                        ),
                        child: ShiftListItem(
                          shift: state.shifts[index],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'No Shifts Yet',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
              } else if (state is AvailableShiftsFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Something went wrong!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                );
              } else {
                return const CircularLoader();
              }
            },
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  Strings.NOT_ENROLLED,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.PROVIDERS,
                        arguments: false,
                      ),
                      child: Text(
                        'Click here ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                    Text(
                      'to explore service providers',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
