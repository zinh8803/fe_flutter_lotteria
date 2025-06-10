import 'dart:convert';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_appflowershop/data/models/cart_item.dart';
import 'package:frontend_appflowershop/data/models/order.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';

class ApiOrderService {
  Future<OrderModel> placeOrder({
    required int userId,
    required String name,
    String? discount_id,
    required String email,
    required String phoneNumber,
    required String address,
    required String paymentMethod,
    required List<CartItem> cartItems,
  }) async {
    const url = '${Constants.baseUrl}/orders';

    final productsList = cartItems
        .asMap()
        .map((index, item) => MapEntry(index, {
              'product_id': item.product.product_id,
              'quantity': item.quantity,
            }))
        .values
        .toList();

    final body = jsonEncode({
      'user_id': userId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'payment_method': paymentMethod,
      'products': productsList,
    });

    print('Request body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      print('Response: ${response.body}');
      return OrderModel.fromJson(json['data']);
    } else {
      print('Error response: ${response.body}');
      throw Exception('Failed to place order: ${response.body}');
    }
  }

  Future<List<OrdergetuserModel>> getallOrder() async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((item) => OrdergetuserModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user orders: ${response.body}');
    }
  }

  Future<List<OrdergetuserModel>> getUserOrders() async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/orders/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((item) => OrdergetuserModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user orders: ${response.body}');
    }
  }

  Future<OrdergetuserModel> getOrderDetail(int orderId) async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await http.get(
        Uri.parse('${Constants.baseUrl}/orders/detail=$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return OrdergetuserModel.fromJson(json['data']);
    } else {
      throw Exception('Failed to load order detail: ${response.body}');
    }
  }
}
