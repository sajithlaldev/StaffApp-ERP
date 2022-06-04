import 'dart:convert';

class FaqModel {
  String id;
  String? created_on;
  String? question;
  String? answer;
  FaqModel({
    this.created_on,
    required this.id,
    this.question,
    this.answer,
  });

  FaqModel copyWith({
    String? question,
    String? id,
    String? answer,
    String? created_on,
  }) {
    return FaqModel(
      created_on: created_on ?? this.created_on,
      answer: answer ?? this.answer,
      question: question ?? this.question,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'id': id,
      'question': question,
      'created_on': created_on,
    };
  }

  factory FaqModel.fromMap(Map<String, dynamic> map) {
    return FaqModel(
      question: map['question'],
      id: map['id'] ?? '',
      answer: map['answer'] ?? '',
      created_on: map['created_on'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqModel.fromJson(String source) =>
      FaqModel.fromMap(json.decode(source));
}
