import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/product/sreach_product/sreach_event.dart';
import 'package:frontend_appflowershop/bloc/product/sreach_product/sreach_state.dart';
import 'package:frontend_appflowershop/data/services/Product/api_product.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService_product apiService;

  SearchBloc(this.apiService) : super(SearchInitial()) {
    on<SearchProductsEvent>((event, emit) async {
      if (event.query.trim().isEmpty) {
        emit(SearchInitial());
        return;
      }

      emit(SearchLoading());
      try {
        final products = await apiService.searchProducts(event.query);
        emit(SearchLoaded(products));
      } catch (e) {
        emit(SearchError('Không thể tìm thấy sản phẩm'));
      }
    });
  }
}
