// lib/models/order.dart
import 'package:cafe_orderr/models/order_item_detail.dart';

class Order {
  final int id;
  // final int? userId; // Uncomment jika Anda punya user_id
  final double totalAmount;
  final String status;
  final String createdAt;
  final List<OrderItemDetail> orderItems; // Nama relasi dari Laravel

  Order({
    required this.id,
    // this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Pastikan 'order_items' adalah nama kunci yang dikirim oleh Laravel
    var itemsList = json['order_items'] as List;
    List<OrderItemDetail> items = itemsList
        .map((itemJson) => OrderItemDetail.fromJson(itemJson))
        .toList();

    return Order(
      id: json['id'],
      // userId: json['user_id'], // Uncomment jika Anda punya user_id
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
      orderItems: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt,
      'order_items': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}