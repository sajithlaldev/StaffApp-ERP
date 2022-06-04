import 'dart:convert';

class ShiftEntryModel {
  String? day;
  String? date;
  String? from;
  String? till;
  String? breakTime;
  String? billableHours;
  String? shiftRef;
  String? authorizedBy;
  ShiftEntryModel({
    this.day,
    this.date,
    this.from,
    this.till,
    this.breakTime,
    this.billableHours,
    this.shiftRef,
    this.authorizedBy,
  });

  bool isEmpty() {
    return day!.isEmpty ||
        date!.isEmpty ||
        from!.isEmpty ||
        till!.isEmpty ||
        breakTime!.isEmpty ||
        billableHours!.isEmpty ||
        shiftRef!.isEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'date': date,
      'from': from,
      'till': till,
      'breakTime': breakTime,
      'billableHours': billableHours,
      'shiftRef': shiftRef,
      'authorizedBy': authorizedBy,
    };
  }

  factory ShiftEntryModel.fromMap(Map<String, dynamic> map) {
    return ShiftEntryModel(
      day: map['day'],
      date: map['date'],
      from: map['from'],
      till: map['till'],
      breakTime: map['breakTime'],
      billableHours: map['billableHours'],
      shiftRef: map['shiftRef'],
      authorizedBy: map['authorizedBy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftEntryModel.fromJson(String source) =>
      ShiftEntryModel.fromMap(json.decode(source));
}
