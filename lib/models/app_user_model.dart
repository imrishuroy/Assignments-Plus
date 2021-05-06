import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AppUser extends Equatable {
  final String? uid;
  final String? name;
  final String? imageUrl;

  AppUser({
    @required this.uid,
    @required this.name,
    @required this.imageUrl,
  });

  @override
  bool? get stringify => true;

  AppUser copyWith({
    String? uid,
    String? name,
    String? imageUrl,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  List<Object?> get props => [uid, name, imageUrl];
}
