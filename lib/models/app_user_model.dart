import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AppUser extends Equatable {
  final String? uid;
  final String? name;
  final String? imageUrl;
  final String? about;
  final String? email;

  const AppUser({
    @required this.uid,
    @required this.name,
    @required this.imageUrl,
    @required this.about,
    @required this.email,
  });

  @override
  bool? get stringify => true;

  static const emptyUser = AppUser(
    uid: '',
    name: '',
    imageUrl: '',
    about: '',
    email: '',
  );

  AppUser copyWith({
    String? uid,
    String? name,
    String? imageUrl,
    String? about,
    String? email,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      about: about ?? this.about,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'about': about,
      'email': email,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic>? map) {
    return AppUser(
      uid: map?['uid'],
      name: map?['name'] ?? '',
      imageUrl: map?['imageUrl'] ?? '',
      about: map?['about'] ?? '',
      email: map?['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  List<Object?> get props => [uid, name, imageUrl, about, email];
}
