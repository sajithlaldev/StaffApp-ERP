import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class ExpenseEntryModel {
  String? day;
  String? date;
  String? type;
  String? desc;
  String? quatity;
  String? poNumber;
  String? unitCosts;
  String? total;
  String? authorizedBy;
  bool? isDrawn;

  GlobalKey<SfSignaturePadState>? signatureKey;

  ExpenseEntryModel({
    this.day,
    this.date,
    this.type,
    this.desc,
    this.quatity,
    this.poNumber,
    this.unitCosts,
    this.total,
    this.authorizedBy,
    this.signatureKey,
    this.isDrawn,
  });

  bool isEmpty() {
    return day!.isEmpty ||
        date!.isEmpty ||
        type!.isEmpty ||
        desc!.isEmpty ||
        quatity!.isEmpty ||
        unitCosts!.isEmpty ||
        total!.isEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'date': date,
      'type': type,
      'desc': desc,
      'quatity': quatity,
      'poNumber': poNumber,
      'unitCosts': unitCosts,
      'total': total,
      'authorizedBy': authorizedBy,
    };
  }

  factory ExpenseEntryModel.fromMap(Map<String, dynamic> map) {
    return ExpenseEntryModel(
      day: map['day'],
      date: map['date'],
      type: map['type'],
      desc: map['desc'],
      quatity: map['quatity'],
      poNumber: map['poNumber'],
      unitCosts: map['unitCosts'],
      total: map['total'],
      authorizedBy: map['authorizedBy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseEntryModel.fromJson(String source) =>
      ExpenseEntryModel.fromMap(json.decode(source));
}
