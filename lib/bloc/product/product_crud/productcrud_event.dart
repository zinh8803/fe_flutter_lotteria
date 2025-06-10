import 'dart:io';
import 'package:frontend_appflowershop/data/models/product.dart';

abstract class ProductcrudEvent {}

class CreateProductEvent extends ProductcrudEvent {
  final ProductModel product;
  final File imageFile;

  CreateProductEvent({
    required this.product,
    required this.imageFile,
  });
}

class UpdateProductEvent extends ProductcrudEvent {
  final ProductModel product;
  final File? imageFile;

  UpdateProductEvent({
    required this.product,
    this.imageFile,
  });
}

class DeleteProductEvent extends ProductcrudEvent {
  final int productId;

  DeleteProductEvent(this.productId);
}
