import 'dart:convert';

class Profession {
  String id;
  String name;

  Profession({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Profession.fromMap(Map<String, dynamic> map) {
    return Profession(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Profession.fromJson(String source) =>
      Profession.fromMap(json.decode(source));
}
