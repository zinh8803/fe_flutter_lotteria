abstract class CategoryProductsEvent {}

class FetchCategoryProductsEvent extends CategoryProductsEvent {
  final int categoryId;

  FetchCategoryProductsEvent(this.categoryId);
}
