import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'profession.dart';

class Staff {
  String name;
  String? search_name;
  String phone;
  String email;
  String? location;
  Timestamp created_on;
  String status;
  List? l;
  String? g;

  Staff({
    required this.name,
    this.search_name,
    required this.phone,
    required this.email,
    this.location,
    required this.created_on,
    required this.status,
    this.l,
    this.g,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'search_name': search_name,
      'phone': phone,
      'email': email,
      'location': location,
      'g': g,
      'l': l,
      'created_on': created_on,
      'status': status,
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      name: map['name'] ?? '',
      search_name: map['search_name'],
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      created_on: map['created_on'] ?? '',
      status: map['status'] ?? '',
      g: map['g'] ?? '',
      l: map['l'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) => Staff.fromMap(json.decode(source));
}
