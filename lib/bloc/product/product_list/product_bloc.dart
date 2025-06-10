import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/data/services/Product/api_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService_product apiService;

  ProductBloc(this.apiService) : super(ProductInitial()) {
    on<FetchProductsEvent>((event, emit) async {
      print('ProductBloc: Handling FetchProductsEvent');
      emit(ProductLoading());
      try {
        final products = await apiService.getProducts();
        print('ProductBloc: Fetched ${products.length} products');
        emit(ProductLoaded(products));
      } catch (e) {
        print('ProductBloc: Error fetching products: $e');
        emit(ProductError(e.toString()));
      }
    });
  }
}
