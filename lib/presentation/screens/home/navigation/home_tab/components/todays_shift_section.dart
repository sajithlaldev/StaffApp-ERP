import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../data/models/shift.dart';
import '../../../../../../logic/bottom_nav/bottom_nav_cubit.dart';
import '../../../../../../logic/home_tab/cubit/home_tab_cubit.dart';
import '../../../../../../utils/strings.dart';

import '../../../../../../utils/assets.dart';
import '../../../../../../utils/colors.dart';
import '../../../../../../utils/styles.dart';
import '../../../../../common/widget_badge.dart';
import '../../../../../common/widgets.dart';

class TodayShiftSection extends StatelessWidget {
  const TodayShiftSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HomeTabCubit, HomeTabState>(
      builder: (context, state) {
        List<Shift>? shifts =
            state is HomeTabLoaded ? state.todaysShifts : null;
        return InkWell(
          onTap: () => context.read<BottomNavsCubit>().onBottomNavSwitch(1),
          child: Stack(
            children: [
              Positioned.fill(
                top: 20,
                left: 2,
                right: 2,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: Styles.boxDecoration(true),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: shifts != null && shifts.isNotEmpty
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.FROM,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: AppColors.primary,
                                            ),
                                      ),
                                      Text(
                                        shifts.first.from
                                            .split(" ")[1]
                                            .substring(0, 5),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(Assets.CLOCK),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            shifts.first.duration,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        width: double.infinity,
                                        child: DashedLine(
                                          color: Colors.white,
                                          height: 2,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        (shifts.first.customer?.address ?? "") +
                                            ", " +
                                            (shifts.first.customer!.post_code),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        Strings.TILL,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: AppColors.primary,
                                            ),
                                      ),
                                      Text(
                                        shifts.first.till
                                            .split(" ")[1]
                                            .substring(0, 5),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Center(
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
                                    Strings.NO_SHIFTS_TODAY,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            )),
                ),
              ),
              Positioned(
                top: 8,
                left: 30,
                child: SizedBox(
                  height: 35,
                  width: size.width * 0.3,
                  child: WidgetBadge(
                    cornerRadius: 4,
                    text: shifts?.length.toString(),
                    child: Container(
                      decoration: Styles.boxDecoration(
                        true,
                        elevation: 1,
                        spreadRadius: 2,
                        cornerRadius: 8,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 10,
                          ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Today\'s Shift',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
