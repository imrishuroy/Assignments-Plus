import 'dart:convert';

import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final bool complete;
  final String id;
  final String title;
  final String todo;
  final DateTime dateTime;
  final int? notificationId;
  final DateTime? notificationDate;

  const TodoEntity(
    this.complete,
    this.id,
    this.title,
    this.todo,
    this.dateTime,
    this.notificationId,
    this.notificationDate,
  );

  @override
  List<Object> get props {
    return [
      complete,
      id,
      title,
      todo,
      dateTime,
      notificationId!,
      notificationDate!,
    ];
  }

  TodoEntity copyWith({
    bool? complete,
    String? id,
    String? title,
    String? todo,
    DateTime? dateTime,
    int? notificationId,
    DateTime? notificationDate,
  }) {
    return TodoEntity(
      complete ?? this.complete,
      id ?? this.id,
      title ?? this.title,
      todo ?? this.todo,
      dateTime ?? this.dateTime,
      notificationId ?? this.notificationId,
      notificationDate ?? this.notificationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'complete': complete,
      'id': id,
      'title': title,
      'todo': todo,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'notificationId': notificationId,
      'notificationDate': notificationDate?.millisecondsSinceEpoch,
    };
  }

  factory TodoEntity.fromMap(Map<String, dynamic> map) {
    return TodoEntity(
      map['complete'],
      map['id'],
      map['title'],
      map['todo'],
      DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      map['notificationId'],
      DateTime.fromMillisecondsSinceEpoch(map['notificationDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoEntity.fromJson(String source) =>
      TodoEntity.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
