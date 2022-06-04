import 'dart:convert';

import '../customer.dart';
import '../service_provider.dart';
import '../staff.dart';
import 'client_auth_model.dart';
import 'expense_entry_model.dart';
import 'shift_entry_model.dart';
import 'staff_section_model.dart';

class TimeSheet {
  String? id;
  String? shift_id;
  String? timesheet_number;
  ServiceProvider? provider;
  Staff? staff;
  Customer? customer;
  String? customerName;
  String? providerId;
  String? staffId;
  String? providerName;
  String? staffName;

  StaffSectionModel? staffSectionModel;
  ClientAuthModel? clientAuthModel;
  ShiftEntryModel? shiftEntry;
  List<ExpenseEntryModel?>? expenseEntries;

  String? agencyWorkerSignature;

  String? created_on;
  TimeSheet({
    this.id,
    this.timesheet_number,
    this.provider,
    this.staff,
    this.shift_id,
    this.customer,
    this.customerName,
    this.providerId,
    this.staffId,
    this.providerName,
    this.staffName,
    this.staffSectionModel,
    this.clientAuthModel,
    this.shiftEntry,
    this.expenseEntries,
    this.agencyWorkerSignature,
    this.created_on,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timesheet_number': timesheet_number,
      'provider': provider?.toMap(),
      'staff': staff?.toMap(),
      'customer': customer?.toMap(),
      'customerName': customerName,
      'providerId': providerId,
      'shift_id': shift_id,
      'staffId': staffId,
      'providerName': providerName,
      'staffName': staffName,
      'staffSectionModel': staffSectionModel?.toMap(),
      'clientAuthModel': clientAuthModel?.toMap(),
      'shiftEntry': shiftEntry?.toMap(),
      'expenseEntries': expenseEntries?.map((x) => x?.toMap()).toList(),
      'agencyWorkerSignature': agencyWorkerSignature,
      'created_on': created_on,
    };
  }

  bool isEmpty() {
    return staffSectionModel!.isEmpty() ||
        shiftEntry!.isEmpty() ||
        expenseEntries!
            .where((element) => element!.isEmpty())
            .toList()
            .isNotEmpty ||
        clientAuthModel!.isEmpty();
  }

  factory TimeSheet.fromMap(Map<String, dynamic> map) {
    return TimeSheet(
      id: map['id'],
      timesheet_number: map['timesheet_number'],
      provider: map['provider'] != null
          ? ServiceProvider.fromMap(map['provider'])
          : null,
      staff: map['staff'] != null ? Staff.fromMap(map['staff']) : null,
      customer:
          map['customer'] != null ? Customer.fromMap(map['customer']) : null,
      customerName: map['customerName'],
      providerId: map['providerId'],
      staffId: map['staffId'],
      shift_id: map['shift_id'],
      providerName: map['providerName'],
      staffName: map['staffName'],
      staffSectionModel: map['staffSectionModel'] != null
          ? StaffSectionModel.fromMap(map['staffSectionModel'])
          : null,
      clientAuthModel: map['clientAuthModel'] != null
          ? ClientAuthModel.fromMap(map['clientAuthModel'])
          : null,
      shiftEntry: map['shiftEntry'] != null
          ? ShiftEntryModel.fromMap(map['shiftEntry'])
          : null,
      expenseEntries: map['expenseEntries'] != null
          ? List<ExpenseEntryModel?>.from(
              map['expenseEntries']?.map((x) => ExpenseEntryModel?.fromMap(x)))
          : null,
      agencyWorkerSignature: map['agencyWorkerSignature'],
      created_on: map['created_on'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSheet.fromJson(String source) =>
      TimeSheet.fromMap(json.decode(source));
}
