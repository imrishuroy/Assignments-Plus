import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_todo/models/entities.dart/todos_entities.dart';

import '../services/todo_entities.dart';

class Todo extends Equatable {
  final String id;
  final String todo;
  final DateTime dateTime;
  final bool completed;

  Todo({
    required this.id,
    required this.todo,
    required this.dateTime,
    this.completed = false,
  });
  // this.id = id;
  //       this.todo = todo;

  @override
  List<Object> get props => [id, todo, dateTime, completed];

  Todo copyWith({
    String? id,
    String? todo,
    DateTime? dateTime,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      dateTime: dateTime ?? this.dateTime,
      completed: completed ?? this.completed,
    );
  }

  TodoEntity todoEntry() {
    return TodoEntity(id, todo, completed, dateTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': todo,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'completed': completed,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      todo: map['todo'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      completed: map['completed'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
