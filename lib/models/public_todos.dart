import 'dart:convert';

import 'package:equatable/equatable.dart';

class PublicTodo extends Equatable {
  final String? title;
  final String? todo;
  final String? authorId;
  final String? todoId;
  final DateTime? dateTime;

  const PublicTodo({
    required this.title,
    required this.todo,
    required this.authorId,
    required this.todoId,
    required this.dateTime,
  });

  static const empty = PublicTodo(
    title: '',
    todo: '',
    authorId: '',
    todoId: '',
    dateTime: null,
  );

  PublicTodo copyWith({
    String? title,
    String? todo,
    String? authorId,
    String? todoId,
    DateTime? dateTime,
  }) {
    return PublicTodo(
      title: title ?? this.title,
      todo: todo ?? this.todo,
      authorId: authorId ?? this.authorId,
      todoId: todoId ?? this.todoId,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'todo': todo,
      'authorId': authorId,
      'todoId': todoId,
      'dateTime': dateTime?.millisecondsSinceEpoch,
    };
  }

  factory PublicTodo.fromMap(Map<String, dynamic>? map) {
    return PublicTodo(
      title: map?['title'] ?? '',
      todo: map?['todo'] ?? '',
      authorId: map?['authorId'] ?? '',
      todoId: map?['todoId'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map?['dateTime'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory PublicTodo.fromJson(String source) =>
      PublicTodo.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      title,
      todo,
      authorId,
      todoId,
      dateTime,
    ];
  }
}
