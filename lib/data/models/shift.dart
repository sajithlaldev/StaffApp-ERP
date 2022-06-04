import 'dart:convert';

import 'customer.dart';
import 'service_provider.dart';
import 'staff.dart';

class Shift {
  String? id;
  String? confirmation_number;
  ServiceProvider provider;
  Staff? staff;
  String? providerId;
  String? staffId;
  String? providerName;
  String? staffName;
  String? customerName;
  Customer? customer;
  String from;
  String till;
  String duration;
  String break_time;
  String? shift_type;
  double? distance;

  String? location_name;
  List? l;
  String? g;

  bool? hot_shift;
  String amount;
  String type;
  String created_on;
  String status;
  Shift({
    this.id,
    this.confirmation_number,
    required this.provider,
    this.staff,
    this.providerId,
    this.staffId,
    this.providerName,
    this.staffName,
    this.customerName,
    this.customer,
    this.location_name,
    this.l,
    this.g,
    required this.from,
    required this.till,
    required this.duration,
    required this.break_time,
    this.shift_type,
    this.distance,
    this.hot_shift,
    required this.amount,
    required this.type,
    required this.created_on,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'confirmation_number': confirmation_number,
      'provider': provider.toMap(),
      'staff': staff?.toMap(),
      'providerId': providerId,
      'staffId': staffId,
      'providerName': providerName,
      'staffName': staffName,
      'customerName': customerName,
      'customer': customer?.toMap(),
      'from': from,
      'till': till,
      'duration': duration,
      'break_time': break_time,
      'shift_type': shift_type,
      'distance': distance,
      'hot_shift': hot_shift,
      'amount': amount,
      'type': type,
      'g': g,
      'l': l,
      'location_name': location_name,
      'created_on': created_on,
      'status': status,
    };
  }

  Map<String, dynamic> toSmallMap() {
    return {
      'id': id,
      'confirmation_number': confirmation_number,
      'providerId': providerId,
      'created_on': created_on,
      'status': status,
    };
  }

  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      id: map['id'] ?? '',
      confirmation_number: map['confirmation_number'],
      provider: ServiceProvider.fromMap(map['provider']),
      staff: map['staff'] != null ? Staff.fromMap(map['staff']) : null,
      providerId: map['providerId'],
      staffId: map['staffId'],
      providerName: map['providerName'],
      staffName: map['staffName'],
      customerName: map['customerName'],
      customer:
          map['customer'] != null ? Customer.fromMap(map['customer']) : null,
      from: map['from'] ?? '',
      till: map['till'] ?? '',
      duration: map['duration'] ?? '',
      break_time: map['break_time'] ?? '',
      shift_type: map['shift_type'],
      distance: map['distance'] ?? 0.0,
      hot_shift: map['hot_shift'],
      amount: map['amount'] ?? '',
      type: map['type'] ?? '',
      created_on: map['created_on'] ?? '',
      status: map['status'] ?? '',
      l: map['l'],
      g: map['g'],
      location_name: map['location_name'] ?? "",
    );
  }
  String toJson() => json.encode(toMap());

  factory Shift.fromJson(String source) => Shift.fromMap(json.decode(source));

  Shift copyWith({
    String? id,
    String? confirmation_number,
    ServiceProvider? provider,
    Staff? staff,
    String? providerId,
    String? staffId,
    String? providerName,
    String? staffName,
    String? customerName,
    Customer? customer,
    String? from,
    String? till,
    String? duration,
    String? break_time,
    String? shift_type,
    double? distance,
    bool? hot_shift,
    String? amount,
    String? type,
    String? created_on,
    String? status,
  }) {
    return Shift(
      id: id ?? this.id,
      confirmation_number: confirmation_number ?? this.confirmation_number,
      provider: provider ?? this.provider,
      staff: staff ?? this.staff,
      providerId: providerId ?? this.providerId,
      staffId: staffId ?? this.staffId,
      providerName: providerName ?? this.providerName,
      staffName: staffName ?? this.staffName,
      customerName: customerName ?? this.customerName,
      customer: customer ?? this.customer,
      from: from ?? this.from,
      till: till ?? this.till,
      duration: duration ?? this.duration,
      break_time: break_time ?? this.break_time,
      shift_type: shift_type ?? this.shift_type,
      distance: distance ?? this.distance,
      hot_shift: hot_shift ?? this.hot_shift,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      created_on: created_on ?? this.created_on,
      status: status ?? this.status,
    );
  }
}
