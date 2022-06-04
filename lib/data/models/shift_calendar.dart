import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShiftCalendarModel {
  ShiftCalendarModel(
      {required this.customer,
      required this.id,
      required this.provider,
      required this.address,
      required this.staff,
      required this.status,
      required this.from,
      required this.to,
      required this.background,
      this.isAllDay = false});

  String id;
  String customer;
  String address;
  String provider;
  String? staff;
  String status;
  DateTime from;

  DateTime to;
  Color background;
  bool isAllDay;
}

class ShiftCalendarDataSource extends CalendarDataSource<ShiftCalendarModel> {
  ShiftCalendarDataSource(List<ShiftCalendarModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].customer;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}
