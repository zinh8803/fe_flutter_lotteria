import 'dart:io';

abstract class CategoryEvent {}

class FetchCategoriesEvent extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String name;
  final String imagePath;

  AddCategoryEvent({
    required this.name,
    required this.imagePath,
  });
}

class UpdateCategoryEvent extends CategoryEvent {
  final int id;
  final String name;
  final String? imagePath;
  final String? currentImageUrl;

  UpdateCategoryEvent({
    required this.id,
    required this.name,
    this.imagePath,
    this.currentImageUrl,
  });
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;

  DeleteCategoryEvent(this.id);
}
