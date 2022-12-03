import 'dart:convert';

import 'package:equatable/equatable.dart';

class ContactUs extends Equatable {
  final String? name;
  final String? email;
  final String? message;
  ContactUs({
    required this.name,
    required this.email,
    required this.message,
  });

  ContactUs copyWith({
    String? name,
    String? email,
    String? message,
  }) {
    return ContactUs(
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'message': message,
    };
  }

  factory ContactUs.fromMap(Map<String, dynamic> map) {
    return ContactUs(
      name: map['name'],
      email: map['email'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactUs.fromJson(String source) =>
      ContactUs.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, email, message];
}
