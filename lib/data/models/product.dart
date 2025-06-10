class ProductModel {
  final int product_id;
  final String name;
  final String? description;
  final double price;
  final int? stock;
  final int? categoryId;
  final String image;

  ProductModel({
    required this.product_id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      product_id: json['product_id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'],
      categoryId: json['category_id'],
      image: json['image'],
    );
  }
}
