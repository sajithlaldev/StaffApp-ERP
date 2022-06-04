import 'dart:convert';

class ServiceProvider {
  String? enrollment_key;
  String name;
  String? search_name;
  String phone;
  String? contact_person;
  String? company_number;
  List? l;
  String? g;

  String type;
  String email;
  String address1;
  String? address2;
  String post_code;
  String city;
  String created_on;
  String status;
  double? distance;

  ServiceProvider({
    this.enrollment_key,
    required this.name,
    this.search_name,
    required this.phone,
    this.contact_person,
    this.company_number,
    required this.type,
    required this.email,
    required this.address1,
    this.address2,
    required this.post_code,
    required this.city,
    required this.created_on,
    required this.status,
    this.l,
    this.g,
  });

  set setDistance(distance) => this.distance = distance;

  Map<String, dynamic> toMap() {
    return {
      'enrollment_key': enrollment_key,
      'name': name,
      'search_name': search_name,
      'phone': phone,
      'contact_person': contact_person,
      'company_number': company_number,
      'type': type,
      'email': email,
      'address1': address1,
      'address2': address2,
      'post_code': post_code,
      'city': city,
      'created_on': created_on,
      'status': status,
    };
  }

  factory ServiceProvider.fromMap(Map<String, dynamic> map) {
    return ServiceProvider(
      enrollment_key: map['enrollment_key'],
      name: map['name'] ?? '',
      search_name: map['search_name'],
      phone: map['phone'] ?? '',
      contact_person: map['contact_person'],
      company_number: map['company_number'],
      type: map['type'] ?? '',
      email: map['email'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'],
      post_code: map['post_code'] ?? '',
      city: map['city'] ?? '',
      created_on: map['created_on'] ?? '',
      status: map['status'] ?? '',
      g: map['g'] ?? '',
      l: map['l'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceProvider.fromJson(String source) =>
      ServiceProvider.fromMap(json.decode(source));
}
