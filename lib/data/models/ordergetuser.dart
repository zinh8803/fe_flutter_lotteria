class OrdergetuserModel {
  final int id;
  final String orderDate;
  final double totalPrice;
  final String status;
  final String name;
  final String phoneNumber;
  final String address;
  final String paymentMethod;
  final List<OrderItemModel> orderItems;

  OrdergetuserModel({
    required this.id,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.paymentMethod,
    required this.orderItems,
  });

  factory OrdergetuserModel.fromJson(Map<String, dynamic> json) {
    return OrdergetuserModel(
      id: json['order_id'],
      orderDate: json['order_date'],
      totalPrice: double.parse(json['total_amount']),
      status: json['status'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      paymentMethod: json['payment_method'],
      orderItems: (json['details'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
    );
  }
}

class OrderItemModel {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final double subtotal;
  final ProductModel product;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['order_detail_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: double.parse(json['price']),
      subtotal: double.parse(json['subtotal']),
      product: ProductModel.fromJson(json),
    );
  }
}

class ProductModel {
  final String name;
  final String image;

  ProductModel({
    required this.name,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      image: json['image'],
    );
  }
}
