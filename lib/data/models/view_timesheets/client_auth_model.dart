import 'dart:convert';

class ClientAuthModel {
  String? name;
  String? thtp;
  String? positionHold;
  String? date;
  String? tetp;
  String? signature;
  ClientAuthModel({
    required this.name,
    required this.thtp,
    required this.positionHold,
    required this.date,
    required this.tetp,
    required this.signature,
  });

  bool isEmpty() {
    return name!.isEmpty ||
        thtp!.isEmpty ||
        positionHold!.isEmpty ||
        date!.isEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'thtp': thtp,
      'positionHold': positionHold,
      'date': date,
      'tetp': tetp,
      'signature': signature,
    };
  }

  factory ClientAuthModel.fromMap(Map<String, dynamic> map) {
    return ClientAuthModel(
      name: map['name'],
      thtp: map['thtp'],
      positionHold: map['positionHold'],
      date: map['date'],
      tetp: map['tetp'],
      signature: map['signature'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientAuthModel.fromJson(String source) =>
      ClientAuthModel.fromMap(json.decode(source));
}
