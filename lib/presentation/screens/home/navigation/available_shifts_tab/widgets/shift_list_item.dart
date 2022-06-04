import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiftapp/logic/available_shifts/cubit/shift_express_cubit.dart';
import '../../../../../../data/models/shift.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../../../../logic/available_shifts/cubit/accept_job_cubit.dart';
import '../../../../../../utils/assets.dart';
import '../../../../../../utils/colors.dart';
import '../../../../../../utils/routes.dart';
import '../../../../../../utils/strings.dart';
import '../../../../../../utils/styles.dart';
import '../../../../../common/default_cofirmation_popup.dart';
import '../../../../../common/widgets.dart';

class ShiftListItem extends StatelessWidget {
  final Shift shift;
  final ValueNotifier<bool> isExpanded = ValueNotifier(false);
  ShiftListItem({
    Key? key,
    required this.shift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ValueListenableBuilder(
      valueListenable: isExpanded,
      builder: (context, value, child) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 8,
                top: 5,
              ),
              decoration: Styles.boxDecoration(value == true ? true : false),
              child: Container(
                color: value == true
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.transparent,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 4,
                ),
                child: AnimatedSize(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 400),
                  child: SizedBox(
                    height: value as bool
                        ? shift.status == "confirmed"
                            ? 320
                            : 290
                        : 120,
                    child: value
                        ? ExpandedShiftItem(
                            shift: shift,
                            isExpanded: isExpanded,
                          )
                        : ShiftItem(
                            shift: shift,
                            isExpanded: isExpanded,
                          ),
                  ),
                ),
              ),
            ),
            if (shift.hot_shift!)
              Positioned(
                left: 3,
                child: Image.asset(
                  Assets.HOT_SHIFT,
                ),
              )
          ],
        );
      },
    );
  }
}

class ShiftItem extends StatelessWidget {
  final Shift shift;
  final ValueNotifier<bool> isExpanded;
  const ShiftItem({
    Key? key,
    required this.shift,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String shiftTimeAsset = shift.shift_type! == "Day Shift"
        ? Assets.DAY_SHIFT
        : shift.shift_type! == "Night Shift"
            ? Assets.NIGHT_SHIFT
            : shift.shift_type! == "Early Shift"
                ? Assets.EARLY_SHIFT
                : Assets.LATE_SHIFT;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: (shift.hot_shift ?? false) ? 12.0 : 0,
                    ),
                    child: Text(
                      Strings.FROM,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ),
                  Text(
                    Utils.formatTimeOnly(shift.from),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                  Text(
                    Utils.formatDateOnlyInReadFormat(shift.from),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.CLOCK),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        shift.duration,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        shiftTimeAsset,
                        color: Colors.white,
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
                  if (shift.status == "confirmed")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.warning,
                          color: Colors.amber,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Not available",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                  // else
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Image.asset(Assets.BREAKTIME),
                  //       const SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         shift.break_time,
                  //         style: Theme.of(context).textTheme.bodyText1,
                  //       ),
                  //       const SizedBox(
                  //         width: 20,
                  //       ),
                  //     ],
                  //   ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    Strings.TILL,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  Text(
                    Utils.formatTimeOnly(shift.till),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    Utils.formatDateOnlyInReadFormat(shift.till),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Center(
          child: GestureDetector(
            onTap: () => isExpanded.value = true,
            child: const Icon(
              Icons.keyboard_arrow_down,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandedShiftItem extends StatelessWidget {
  final Shift shift;
  final ValueNotifier<bool> isExpanded;

  const ExpandedShiftItem({
    Key? key,
    required this.shift,
    required this.isExpanded,
  }) : super(key: key);

  showAcceptJobPopup(BuildContext context, {required String id}) async {
    var res = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => AcceptJobCubit(),
        child: BlocConsumer<AcceptJobCubit, AcceptJobState>(
          listener: (context, state) {
            if (state is AcceptJobSuccess) {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.HOME,
                (route) => false,
              );
            } else if (state is AcceptJobFailure) {
              Navigator.pop(context);
              Utils.showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            return DefaultConfirmationPopup(
              title: Strings.ACCEPT_JOB,
              caption: Strings.ACCEPT_JOB_CAPTION,
              yesText: Strings.ACCEPT_JOB,
              isLoading: state is AcceptJobSendLoading ? true : false,
              yesFunction: () {
                BlocProvider.of<AcceptJobCubit>(context).AcceptJobPressed(
                  shiftId: shift.id!,
                  staff: (context.read<AuthenticationCubit>().state
                          as AuthenticationSuccess)
                      .staff,
                );
              },
            );
          },
        ),
      ),
    );
  }

  showExpressInterestPopup(BuildContext context, {required String id}) async {
    var res = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => AcceptJobCubit(),
        child: BlocConsumer<AcceptJobCubit, AcceptJobState>(
          listener: (context, state) {
            if (state is AcceptJobSuccess) {
              Navigator.pop(context);
            } else if (state is AcceptJobFailure) {
              Navigator.pop(context);
              Utils.showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            return DefaultConfirmationPopup(
              title: Strings.EXPRESS_INTEREST,
              caption: Strings.SHIFT_EXPRESS_INTEREST_CAPTION,
              yesText: Strings.OK,
              isLoading: state is AcceptJobSendLoading ? true : false,
              yesFunction: () {
                BlocProvider.of<AcceptJobCubit>(context).expressInterestPressed(
                  shiftId: shift.id!,
                  staff: (context.read<AuthenticationCubit>().state
                          as AuthenticationSuccess)
                      .staff,
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String shiftTimeAsset = shift.shift_type! == "Day Shift"
        ? Assets.DAY_SHIFT
        : shift.shift_type! == "Night Shift"
            ? Assets.NIGHT_SHIFT
            : shift.shift_type! == "Early Shift"
                ? Assets.EARLY_SHIFT
                : Assets.LATE_SHIFT;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: (shift.hot_shift ?? false) ? 10.0 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift.customer?.name ?? "",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        shift.customer!.address +
                            ", " +
                            shift.customer!.post_code,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (shift.distance != null && shift.distance != 0)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 16,
                  ),
                  Text(
                    Utils.meterToMiles(shift.distance ?? 0.0)
                            .toStringAsFixed(2) +
                        " Miles",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          thickness: 0.7,
          color: AppColors.primary.withOpacity(0.5),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    Strings.FROM,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  Text(
                    Utils.formatTimeOnly(shift.from),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                  Text(
                    Utils.formatDateOnlyInReadFormat(shift.from),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.CLOCK),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        shift.duration,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        shiftTimeAsset,
                        color: Colors.white,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.BREAKTIME),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        shift.break_time,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
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
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    Strings.TILL,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  Text(
                    Utils.formatTimeOnly(shift.till),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    Utils.formatDateOnlyInReadFormat(shift.till),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        if (shift.status == "confirmed")
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.warning,
                color: Colors.amber,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Not available",
                style: TextStyle(
                  color: Colors.amber,
                ),
              )
            ],
          ),
        const SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          thickness: 0.7,
          color: AppColors.primary.withOpacity(0.5),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.AMOUNT,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Image.asset(Assets.POUNDS),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      shift.amount,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Strings.TYPE,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  shift.type,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.PROVIDER,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  shift.provider.name,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            if (shift.status == "pooled")
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () async {
                    showAcceptJobPopup(
                      context,
                      id: shift.id!,
                    );
                  },
                  child: const Text(
                    Strings.ACCEPT_JOB,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            if (shift.status == "completed")
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pushNamed(
                      context,
                      Routes.TIMESHEET,
                      arguments: shift,
                    );
                  },
                  child: const Text(
                    Strings.VIEW_TIMESHEET,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            if (shift.status == "confirmed")
              BlocProvider(
                create: (context) => ShiftExpressCubit(shift),
                child: BlocBuilder<ShiftExpressCubit, ShiftExpressState>(
                  builder: (context, state) {
                    if (!state.isExpressSent!) {
                      return SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style:
                              Styles.SECONDARY_ELEVATED_BUTTON_THEME.copyWith(
                            foregroundColor: MaterialStateProperty.all(
                              AppColors.primary,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            showExpressInterestPopup(
                              context,
                              id: shift.id!,
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                Assets.HEART,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                Strings.EXPRESS_INTEREST,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Row(
                        children: [
                          Image.asset(
                            Assets.EXPRESS_PENDING,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Pending',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: AppColors.primary,
                                    ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              )
          ],
        ),
        Center(
          child: GestureDetector(
            onTap: () => isExpanded.value = false,
            child: const Icon(
              Icons.keyboard_arrow_up,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
