import 'dart:convert';

import 'package:assignments/config/paths.dart';
import 'package:assignments/enums/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';

import 'package:assignments/models/app_user_model.dart';
import 'package:assignments/models/public_todos.dart';

class Activity extends Equatable {
  final String? id;
  final ActivityType? type;
  final AppUser? fromUser;
  final PublicTodo? todo;
  final DateTime? dateTime;
  Activity({
    required this.id,
    required this.type,
    required this.fromUser,
    required this.todo,
    required this.dateTime,
  });

  Activity copyWith({
    String? id,
    ActivityType? type,
    AppUser? fromUser,
    PublicTodo? todo,
    DateTime? dateTime,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      fromUser: fromUser ?? this.fromUser,
      todo: todo ?? this.todo,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    final notifType = EnumToString.convertToString(type);
    return {
      'id': id,
      'type': notifType,
      'fromUser':
          FirebaseFirestore.instance.collection(Paths.users).doc(fromUser?.uid),
      //'todo': todo?.toMap(),
      'todo': todo != null
          ? FirebaseFirestore.instance
              .collection(Paths.public)
              .doc(todo?.todoId)
          : null,
      'dateTime': dateTime?.millisecondsSinceEpoch,
    };
  }

  static Future<Activity?> fromDocument(DocumentSnapshot? doc) async {
    if (doc == null) return null;
    print('it runs ----------------');
    final data = doc.data() as Map?;
    final ActivityType? notificationType =
        EnumToString.fromString(ActivityType.values, data?['type']);

    // From User
    final fromUserRef = data?['fromUser'] as DocumentReference?;
    if (fromUserRef != null) {}
    final fromUserDoc = await fromUserRef?.get();
    print('From user -------------- $fromUserDoc');

    // Post

    final todoRef = data?['todo'] as DocumentReference?;

    final todoDoc = await todoRef?.get();

    print('todo ------------- $todoDoc');

    return Activity(
      id: data?['id'],
      type: notificationType,
      fromUser: AppUser.fromMap(fromUserDoc?.data() as Map<String, dynamic>?),
      todo: PublicTodo.fromMap(todoDoc?.data() as Map<String, dynamic>),
      dateTime: DateTime.fromMillisecondsSinceEpoch(data?['dateTime']),
    );
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    final ActivityType? notificationType =
        EnumToString.fromString(ActivityType.values, map['type']);

    return Activity(
      id: map['id'],
      type: notificationType,
      fromUser: AppUser.fromMap(map['fromUser']),
      todo: PublicTodo.fromMap(map['todo']),
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Activity.fromJson(String source) =>
      Activity.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      type,
      fromUser,
      todo,
      dateTime,
    ];
  }
}
