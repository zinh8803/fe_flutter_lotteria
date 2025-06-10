import 'package:frontend_appflowershop/data/models/position.dart';

class EmployeeModel {
  final int id;
  final String name;
  final Position position;
  final String email;
  final String phone;
  final String address;
  final String token;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.position,
    required this.email,
    required this.phone,
    required this.address,
    required this.token,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json, String token) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      position: Position.fromJson(json['position']),
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      token: token,
    );
  }
}
