import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final bool complete;
  final String id;
  final String todo;
  final DateTime dateTime;

  const TodoEntity(this.id, this.todo, this.complete, this.dateTime);

  Map<String, Object> toJson() {
    return {
      'complete': complete,
      'note': todo,
      'id': id,
      'date': dateTime,
    };
  }

  @override
  List<Object> get props => [complete, id, todo, dateTime];

  @override
  String toString() {
    return 'TodoEntity { complete: $complete, date: $dateTime, note: $todo, id: $id }';
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
      json['todo'] as String,
      json['id'] as String,
      json['complete'] as bool,
      json['date'] as DateTime,
    );
  }

  static TodoEntity fromSnapshot(DocumentSnapshot snap) {
    return TodoEntity(snap.data()?['todo'], snap.id, snap.data()?['complete'],
        snap.data()?['date']);
  }

  Map<String, Object> toDocument() {
    return {
      'complete': complete,
      'todo': todo,
      'date': dateTime,
    };
  }
}
