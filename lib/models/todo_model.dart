import 'dart:convert';

import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String todo;
  final DateTime dateTime;
  final bool completed;
  final int? notificationId;
  final DateTime? notificationDate;

  Todo({
    required this.id,
    required this.todo,
    required this.title,
    required this.dateTime,
    this.completed = false,
    this.notificationDate,
    this.notificationId,
  });

  @override
  List<Object> get props => [
        id,
        todo,
        dateTime,
        completed,
        title,
        notificationDate!,
        notificationId!,
      ];

  Todo copyWith({
    String? id,
    String? todo,
    DateTime? dateTime,
    bool? completed,
    String? imageUrl,
    String? title,
    DateTime? notificationDate,
    int? notificationId,
  }) {
    return Todo(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      dateTime: dateTime ?? this.dateTime,
      completed: completed ?? this.completed,
      title: title ?? this.title,
      notificationDate: notificationDate ?? this.notificationDate,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  Map<String, dynamic> toMap() {
    print('Map runs-------------');
    return {
      'id': id,
      'todo': todo,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'completed': completed,
      'title': title,
      'notificationId': notificationId,
      'notificationDate': notificationDate?.millisecondsSinceEpoch,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    //  print('------------------------${map['notificationDate']}');
    return Todo(
      id: map['id'],
      todo: map['todo'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      completed: map['completed'],
      title: map['title'],
      notificationDate:
          DateTime.fromMillisecondsSinceEpoch(map['notificationDate']),
      notificationId: map['notificationId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
