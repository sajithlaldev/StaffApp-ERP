import 'dart:convert';

class EKey {
  String key;
  String? provider;
  String? provider_name;
  String? staff;
  String? staff_name;
  String created_on;
  EKey({
    required this.key,
    this.provider,
    this.provider_name,
    this.staff,
    this.staff_name,
    required this.created_on,
  });

  


  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'provider': provider,
      'provider_name': provider_name,
      'staff': staff,
      'staff_name': staff_name,
      'created_on': created_on,
    };
  }

  factory EKey.fromMap(Map<String, dynamic> map) {
    return EKey(
      key: map['key'] ?? '',
      provider: map['provider'],
      provider_name: map['provider_name'],
      staff: map['staff'],
      staff_name: map['staff_name'],
      created_on: map['created_on'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EKey.fromJson(String source) => EKey.fromMap(json.decode(source));
}
