import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/shift.dart';
import '../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../logic/available_shifts/cubit/accept_job_cubit.dart';
import 'components/map_section.dart';
import 'components/confirmation_details_section.dart';
import '../../../utils/colors.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';
import 'package:intl/intl.dart';
import '../../common/default_cofirmation_popup.dart';
import 'components/app_bar.dart';

class ShiftConfirmationScreen extends StatelessWidget {
  final Shift shift;
  const ShiftConfirmationScreen({
    Key? key,
    required this.shift,
  }) : super(key: key);

  void _launchURL(_url) async {
    if (!await launch(_url.toString())) throw 'Could not launch $_url';
  }

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

  showFinishPopup(BuildContext context, {required Shift shift}) async {
    var res = await showDialog(
      context: context,
      builder: (context) => DefaultConfirmationPopup(
        title: Strings.FINISH_SHIFT,
        caption: Strings.FINISH_JOB_CAPTION,
        yesText: Strings.FINISH_SHIFT,
        yesFunction: () {
          if (DateTime.now()
              .isAfter(DateFormat("yyyy-MM-dd HH:mm").parse(shift.till))) {
            Navigator.pushNamed(
              context,
              Routes.TIMESHEET,
              arguments: shift,
            );
          } else {
            Utils.showSnackBar(context, "Shift time is not over");
          }
        },
      ),
    );
  }

  showFinishBerforeTillPopup(BuildContext context,
      {required Shift shift}) async {
    var res = await showDialog(
      context: context,
      builder: (context) => DefaultConfirmationPopup(
        title: Strings.OOPSS,
        caption: Strings.FINISH_SHIFT_BEFORE_TILL_CAPTION,
        yesText: Strings.CALL,
        yesFunction: () {
          _launchURL(
            "tel:+44" + shift.provider.phone,
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  showCancelAfterThresholdShiftPopup(BuildContext context,
      {required Shift shift}) async {
    var res = await showDialog(
      context: context,
      builder: (context) => DefaultConfirmationPopup(
        title: Strings.OOPSS,
        caption: Strings.CANCEL_SHIFT_AFTER_THRESHOLD_CAPTION,
        yesText: Strings.CALL,
        yesFunction: () {
          _launchURL(
            "tel:+44" + shift.provider.phone,
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  showCancelShiftPopup(BuildContext context, {required Shift shift}) async {
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
              title: Strings.CANCEL_SHIFT,
              caption: Strings.CANCEL_SHIFT_CAPTION,
              yesText: Strings.CANCEL_SHIFT,
              isLoading: state is AcceptJobSendLoading ? true : false,
              yesFunction: () {
                if (DateTime.now().isBefore(DateFormat("yyyy-MM-dd HH:mm")
                    .parse(shift.from)
                    .subtract(const Duration(
                      hours: 2,
                      minutes: 30,
                    )))) {
                  BlocProvider.of<AcceptJobCubit>(context).cancelJobPressed(
                    shift: shift,
                    staff: (context.read<AuthenticationCubit>().state
                            as AuthenticationSuccess)
                        .staff!,
                  );
                } else {
                  Utils.showSnackBar(
                      context, "You cannot cancel this shift anymore!");
                }
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return ConstrainedBox(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                MapSection(shift: shift),
                const SizedBox(
                  height: 16,
                ),
                ConfirmationDetailsSection(shift: shift),
                if (shift.status == "pooled")
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showAcceptJobPopup(context, id: shift.id!);
                        },
                        child: const Text(
                          Strings.ACCEPT_JOB,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                else if (shift.status == "confirmed" &&
                    shift.staff!.email ==
                        FirebaseAuth.instance.currentUser!.email)
                  Row(
                    children: [
                      if (DateTime.now().isBefore(
                          DateFormat("yyyy-MM-dd HH:mm").parse(shift.from)))
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (DateTime.now().isBefore(
                                    DateFormat("yyyy-MM-dd HH:mm")
                                        .parse(shift.from)
                                        .subtract(const Duration(
                                          hours: 2,
                                        )))) {
                                  showCancelShiftPopup(
                                    context,
                                    shift: shift,
                                  );
                                } else {
                                  showCancelAfterThresholdShiftPopup(
                                    context,
                                    shift: shift,
                                  );
                                }
                              },
                              child: const Text(
                                Strings.CANCEL_SHIFT,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (DateTime.now().isAfter(
                          DateFormat("yyyy-MM-dd HH:mm").parse(shift.from)))
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (DateTime.now().isAfter(
                                    DateFormat("yyyy-MM-dd HH:mm")
                                        .parse(shift.till))) {
                                  showFinishPopup(context, shift: shift);
                                } else {
                                  showFinishBerforeTillPopup(
                                    context,
                                    shift: shift,
                                  );
                                }
                              },
                              child: const Text(
                                Strings.FINISH_SHIFT,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  )
                else if (shift.status == "completed")
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.TIMESHEET,
                            arguments: shift,
                          );
                        },
                        child: const Text(
                          Strings.VIEW_TIMESHEET,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
