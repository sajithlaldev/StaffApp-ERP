import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../../logic/date_range_selector_cubit/date_range_selector_cubit.dart';
import '../../../../logic/past_shifts/cubit/past_shifts_cubit.dart';
import '../../../../logic/tabs/tabs_cubit.dart';
import '../../home/navigation/available_shifts_tab/widgets/shift_list_item.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/utils.dart';

import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../common/circular_progress.dart';

class PastShiftsSection extends StatelessWidget {
  const PastShiftsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess 
          ) {
          return BlocListener<DateRangeSelectorCubit, DateRangeSelectorState>(
            listener: (context, state) {
              if (state is DateRangeSelectorLoaded) {
                BlocProvider.of<PastShiftsCubit>(context).loadShifts(
                    status: context.read<TabsCubit>().state.currentIndex == 0
                        ? "completed"
                        : "cancelled",
                    filters: [
                      {
                        "name": "from",
                        "value": state.fromDate.toString(),
                      },
                      {
                        "name": "till",
                        "value": state.tillDate.toString().split(" ")[0] +
                            " 23:59:00",
                      }
                    ]);
              }
            },
            child: BlocConsumer<PastShiftsCubit, PastShiftsState>(
              listener: (context, state) {
                if (state is PastShiftsFailure) {
                  Utils.showSnackBar(context, state.message.split("\n").first);
                }
              },
              builder: (context, state) {
                if (state is PastShiftsLoaded) {
                  if (state.shifts.isNotEmpty) {
                    String currentDate = "";
                    return ListView.builder(
                      itemCount: state.shifts.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String date = Utils.formatDateOnlyInReadFormat(
                            state.shifts[index].from);
                        if (currentDate != date) {
                          currentDate = date;
                        } else {
                          date = "";
                        }
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/confirmation',
                            arguments: state.shifts[index],
                          ),
                          child: Column(
                            children: [
                              if (date.isNotEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Utils.formatDateOnlyInReadFormat(
                                          state.shifts[index].from),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: AppColors.primary,
                                          ),
                                    ),
                                  ),
                                ),
                              ShiftListItem(
                                shift: state.shifts[index],
                              ),
                            ],
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
                } else if (state is PastShiftsFailure) {
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
            ),
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
