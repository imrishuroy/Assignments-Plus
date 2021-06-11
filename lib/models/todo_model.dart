import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_todo/models/entities.dart/todos_entities.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String todo;
  final DateTime dateTime;
  final bool completed;
  final String imageUrl;

  Todo({
    required this.id,
    required this.todo,
    required this.title,
    required this.dateTime,
    this.completed = false,
    required this.imageUrl,
  });
  // this.id = id;
  //       this.todo = todo;

  @override
  List<Object> get props => [
        id,
        todo,
        dateTime,
        completed,
        this.imageUrl,
        title,
      ];

  Todo copyWith({
    String? id,
    String? todo,
    DateTime? dateTime,
    bool? completed,
    String? imageUrl,
    String? title,
  }) {
    return Todo(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      dateTime: dateTime ?? this.dateTime,
      completed: completed ?? this.completed,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
    );
  }

  TodoEntity todoEntry() {
    return TodoEntity(id, todo, completed, dateTime, imageUrl, title);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': todo,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'completed': completed,
      'imageUrl': imageUrl,
      'title': title,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
        id: map['id'],
        todo: map['todo'],
        dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
        completed: map['completed'],
        imageUrl: map['imageUrl'],
        title: map['title']);
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
