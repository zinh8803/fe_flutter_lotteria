import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/data/services/Product/api_product.dart';
import 'category_products_event.dart';
import 'category_products_state.dart';

class CategoryProductsBloc
    extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  final ApiService_product apiService;

  CategoryProductsBloc(this.apiService) : super(CategoryProductsInitial()) {
    on<FetchCategoryProductsEvent>((event, emit) async {
      emit(CategoryProductsLoading());
      try {
        final products =
            await apiService.getProductsByCategory(event.categoryId);
        emit(CategoryProductsLoaded(products));
      } catch (e) {
        emit(CategoryProductsError(e.toString()));
      }
    });
  }
}
