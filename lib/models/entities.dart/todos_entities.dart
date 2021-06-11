import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final bool complete;
  final String id;
  final String title;
  final String todo;
  final DateTime dateTime;
  final String imageUrl;

  const TodoEntity(
    this.id,
    this.todo,
    this.complete,
    this.dateTime,
    this.imageUrl,
    this.title,
  );

  Map<String, Object> toJson() {
    return {
      'complete': complete,
      'note': todo,
      'id': id,
      'date': dateTime,
      'imageUrl': imageUrl,
      'title': title,
    };
  }

  @override
  List<Object> get props => [complete, id, todo, dateTime, imageUrl, title];

  @override
  String toString() {
    return 'TodoEntity { complete: $complete, date: $dateTime, note: $todo, id: $id , imageUrl: $imageUrl, title: $title}';
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
      json['todo'] as String,
      json['id'] as String,
      json['complete'] as bool,
      json['date'] as DateTime,
      json['imageUrl'] as String,
      json['title'] as String,
    );
  }

  static TodoEntity fromSnapshot(DocumentSnapshot snap) {
    return TodoEntity(
      snap.data()?['todo'],
      snap.id,
      snap.data()?['complete'],
      snap.data()?['imageUrl'],
      snap.data()?['date'],
      snap.data()?['title'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'complete': complete,
      'todo': todo,
      'date': dateTime,
      'imageUrl': imageUrl,
      'title': title,
    };
  }
}
