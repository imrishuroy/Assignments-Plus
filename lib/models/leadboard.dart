import 'dart:convert';

import 'package:equatable/equatable.dart';

class LeadBoard extends Equatable {
  final String name;
  final int position;
  final String imageUrl;
  final int pastPosition;

  LeadBoard({
    required this.name,
    required this.position,
    required this.imageUrl,
    required this.pastPosition,
  });

  @override
  List<Object> get props => [name, position, imageUrl, pastPosition];

  LeadBoard copyWith({
    String? name,
    int? position,
    String? imageUrl,
    int? pastPosition,
  }) {
    return LeadBoard(
      name: name ?? this.name,
      position: position ?? this.position,
      imageUrl: imageUrl ?? this.imageUrl,
      pastPosition: pastPosition ?? this.pastPosition,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'imageUrl': imageUrl,
      'pastPosition': pastPosition,
    };
  }

  factory LeadBoard.fromMap(Map<String, dynamic> map) {
    return LeadBoard(
      name: map['name'],
      position: map['position'],
      imageUrl: map['imageUrl'],
      pastPosition: map['pastPosition'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadBoard.fromJson(String source) =>
      LeadBoard.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
