// lib/models/order_item_detail.dart
import 'package:cafe_orderr/models/menu_item.dart';

class OrderItemDetail {
  final int id;
  final int orderId;
  final int menuId;
  final int quantity;
  final double priceAtOrder;
  final MenuItem? menu; // Relasi menu, bisa null jika tidak diload

  OrderItemDetail({
    required this.id,
    required this.orderId,
    required this.menuId,
    required this.quantity,
    required this.priceAtOrder,
    this.menu,
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) {
    return OrderItemDetail(
      id: json['id'],
      orderId: json['order_id'],
      menuId: json['menu_id'],
      quantity: json['quantity'],
      priceAtOrder: (json['price_at_order'] as num).toDouble(),
      menu: json['menu'] != null ? MenuItem.fromJson(json['menu']) : null, // Parse nested Menu item
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'menu_id': menuId,
      'quantity': quantity,
      'price_at_order': priceAtOrder,
      'menu': menu?.toJson(),
    };
  }
}