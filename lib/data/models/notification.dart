import 'dart:convert';

class NotificationModel {
  String? key;
  String id;
  String type;
  String? created_on;
  String? created_by;
  Map<String, dynamic>? created_by_name;
  String? title;
  String? message;
  bool? read;
  NotificationModel({
    this.key,
    required this.id,
    required this.type,
    this.created_on,
    this.created_by,
    this.title,
    this.message,
    this.read,
    this.created_by_name,
  });

  NotificationModel copyWith({
    String? key,
    String? id,
    String? type,
    String? created_on,
    String? created_by,
    String? title,
    String? message,
    bool? read,
  }) {
    return NotificationModel(
      key: key ?? this.key,
      id: id ?? this.id,
      type: type ?? this.type,
      created_on: created_on ?? this.created_on,
      created_by: created_by ?? this.created_by,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'id': id,
      'type': type,
      'created_on': created_on,
      'created_by': created_by,
      'title': title,
      'message': message,
      'read': read,
      'created_by_name': created_by_name,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      key: map['key'],
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      created_on: map['created_on'],
      created_by: map['created_by'],
      title: map['title'],
      message: map['message'],
      read: map['read'],
      created_by_name: map['created_by_name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(key: $key, id: $id, type: $type, created_on: $created_on, created_by: $created_by, title: $title, message: $message, read: $read)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.key == key &&
        other.id == id &&
        other.type == type &&
        other.created_on == created_on &&
        other.created_by == created_by &&
        other.title == title &&
        other.message == message &&
        other.read == read;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        id.hashCode ^
        type.hashCode ^
        created_on.hashCode ^
        created_by.hashCode ^
        title.hashCode ^
        message.hashCode ^
        read.hashCode;
  }
}
