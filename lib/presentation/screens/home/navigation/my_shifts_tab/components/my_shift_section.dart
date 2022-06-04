import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../logic/date_selector_cubit/date_selector_cubit.dart';
import '../../../../../../logic/my_shifts/cubit/my_shifts_cubit.dart';
import '../../../../../../utils/colors.dart';
import '../../../../../../utils/routes.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../../data/models/shift.dart';
import '../../../../../../data/models/shift_calendar.dart';
import '../widgets/appointment_widget.dart';

class MyShiftsSection extends StatelessWidget {
  final CalendarController controller;

  const MyShiftsSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
        left: 8,
      ),
      child: BlocBuilder<MyShiftsCubit, MyShiftsState>(
        builder: (context, state) {
          List<Shift> shifts = state is MyShiftsLoaded ? state.shifts : [];
          print("Shifts : " + shifts.length.toString());
          return Column(
            children: [
              if (state is MyShiftsLoading)
                const LinearProgressIndicator(
                  color: AppColors.primary,
                ),
              Expanded(
                child: SfCalendar(
                  controller: controller,
                  showDatePickerButton: false,
                  showNavigationArrow: false,
                  view: CalendarView.day,
                  dataSource: _getCalendarDataSource(shifts),
                  timeSlotViewSettings: TimeSlotViewSettings(
                    timeIntervalHeight: _size.height * 0.06,
                    timeTextStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  onViewChanged: (details) {
                    BlocProvider.of<DateSelectorCubit>(context)
                        .setDate(details.visibleDates[0]);
                  },
                  appointmentBuilder: (context, appointment) {
                    if (appointment.appointments.isEmpty) {
                      return const SizedBox();
                    } else {
                      for (int i = 0;
                          i < appointment.appointments.length;
                          i++) {
                        ShiftCalendarModel shiftCalendarModel =
                            appointment.appointments.elementAt(i);

                        return InkWell(
                          onTap: () {
                            Shift shift = shifts.firstWhere(
                              ((element) =>
                                  element.id == shiftCalendarModel.id),
                            );

                            Navigator.pushNamed(
                              context,
                              Routes.CONFIRMATION,
                              arguments: shift,
                            );
                          },
                          child: ShiftCalenderWidget(
                            shiftCalendarModel: shiftCalendarModel,
                          ),
                        );
                      }
                    }
                    return const SizedBox();
                  },
                  viewHeaderHeight: 0,
                  viewHeaderStyle: const ViewHeaderStyle(
                    dayTextStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    dateTextStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  cellEndPadding: 0,
                  showWeekNumber: false,
                  cellBorderColor: Colors.grey,
                  todayTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  todayHighlightColor: AppColors.primary,
                  showCurrentTimeIndicator: true,
                  headerHeight: 0,
                  backgroundColor: AppColors.accent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

ShiftCalendarDataSource _getCalendarDataSource(List<Shift> shifts) {
  List<ShiftCalendarModel> appointments = <ShiftCalendarModel>[];

  for (var shift in shifts) {
    DateTime from = DateTime.parse(shift.from);

    DateTime till = DateTime.parse(shift.till);

    appointments.add(
      ShiftCalendarModel(
        from: from,
        to: till,
        id: shift.id!,
        status: shift.status,
        customer: shift.customer!.name,
        address: shift.customer!.address + ", " + shift.customer!.post_code,
        staff: shift.staff?.name ?? "",
        background: Colors.blue,
        provider: shift.provider.name,
      ),
    );
  }

  return ShiftCalendarDataSource(appointments);
}
