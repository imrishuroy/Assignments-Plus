import 'dart:convert';

import 'package:equatable/equatable.dart';

class PublicTodo extends Equatable {
  final String? title;
  final String? todo;
  final String? authorId;
  final String? todoId;

  PublicTodo({
    required this.title,
    required this.todo,
    required this.authorId,
    required this.todoId,
  });

  PublicTodo copyWith({
    String? title,
    String? todo,
    String? authorId,
    String? todoId,
  }) {
    return PublicTodo(
      title: title ?? this.title,
      todo: todo ?? this.todo,
      authorId: authorId ?? this.authorId,
      todoId: todoId ?? this.todoId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'todo': todo,
      'authorId': authorId,
      'todoId': todoId,
    };
  }

  factory PublicTodo.fromMap(Map<String, dynamic> map) {
    return PublicTodo(
        title: map['title'],
        todo: map['todo'],
        authorId: map['authorId'],
        todoId: map['todoId']);
  }

  String toJson() => json.encode(toMap());

  factory PublicTodo.fromJson(String source) =>
      PublicTodo.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [title, todo, authorId, todoId];
}
