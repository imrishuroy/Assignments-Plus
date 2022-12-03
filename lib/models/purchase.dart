import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Purchase extends Equatable {
  final String? iapSource;
  final String? orderId;
  final String? productId;
  final DateTime? purchaseDate;
  final String status;
  final String? type;
  final String? userId;
  Purchase({
    this.iapSource,
    this.orderId,
    this.productId,
    this.purchaseDate,
    required this.status,
    this.type,
    this.userId,
  });

  Purchase copyWith({
    String? iapSource,
    String? orderId,
    String? productId,
    DateTime? purchaseDate,
    String? status,
    String? type,
    String? userId,
  }) {
    return Purchase(
      iapSource: iapSource ?? this.iapSource,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      status: status ?? this.status,
      type: type ?? this.type,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iapSource': iapSource,
      'orderId': orderId,
      'productId': productId,
      'purchaseDate': Timestamp.fromDate(purchaseDate ?? DateTime.now()),
      'status': status,
      'type': type,
      'userId': userId,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      iapSource: map['iapSource'] ?? '',
      orderId: map['orderId'] ?? '',
      productId: map['productId'] ?? '',
      purchaseDate:
          (map['purchaseDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? '',
      type: map['type'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Purchase.fromJson(String source) =>
      Purchase.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [iapSource, orderId, productId, purchaseDate, status, type, userId];
  }
}
