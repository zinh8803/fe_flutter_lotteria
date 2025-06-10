class UserModel {
  final int user_id;
  final String username;
  final String email;
  final String? password;
  final String? avatar;
  final String? phoneNumber;
  final String? address;
  final int isAdmin;

  final String? token;

  UserModel({
    required this.user_id,
    required this.username,
    required this.email,
    this.password,
    this.avatar,
    this.phoneNumber,
    this.address,
    required this.isAdmin,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String? token) {
    return UserModel(
      user_id: json['user_id'],
      username: json['username'],
      email: json['email'],
      password: null,
      avatar: json['avatar'],
      phoneNumber:
          json['phone_number'] == null ? '' : json['phone_number'].toString(),
      address: json['address'] == null ? '' : json['address'].toString(),
      isAdmin: json['isAdmin'] ?? 0,
      token: token,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'username': username,
      'email': email,
      'password': password,
      'avatar': avatar,
      'phone_number': phoneNumber == null ? '' : phoneNumber.toString(),
      'address': address == null ? '' : address.toString(),
      'isAdmin': isAdmin,
      'token': token,
    };
  }
}
