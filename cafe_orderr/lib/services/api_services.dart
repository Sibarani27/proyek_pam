// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cafe_orderr/models/menu_item.dart';
import 'package:cafe_orderr/models/order.dart'; // Sudah pakai Order model baru

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // Sesuaikan jika berbeda

  Future<List<MenuItem>> getMenuItems() async {
    final response = await http.get(Uri.parse('$baseUrl/menu'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => MenuItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load menu items: ${response.statusCode} ${response.body}');
    }
  }

  Future<Order> createOrder(List<Map<String, dynamic>> menuItemsData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/order'), // >>> Tetap '/order' untuk POST order baru
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
      },
      body: jsonEncode(<String, dynamic>{
        'menu_items': menuItemsData, // Kirim data array item menu
        // 'user_id': 1, // Jika ada user_id
      }),
    );

    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      print('Error creating order: ${response.statusCode} ${response.body}');
      throw Exception('Failed to create order: ${response.statusCode} ${response.body}');
    }
  }

  // Contoh: mengambil semua order (menggunakan '/orders' jika Anda mengimplementasikannya)
  Future<List<Order>> getOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/orders')); // GET ke /api/orders

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.statusCode} ${response.body}');
    }
  }

  // Contoh: mengambil detail satu order
  Future<Order> getOrderById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/order/$id')); // GET ke /api/order/{id}

    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load order: ${response.statusCode} ${response.body}');
    }
  }
}