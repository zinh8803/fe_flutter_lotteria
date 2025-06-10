import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/data/services/Product/api_product.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ApiService_product apiService;

  ProductDetailBloc(this.apiService) : super(ProductDetailInitial()) {
    on<FetchProductDetailEvent>((event, emit) async {
      emit(ProductDetailLoading());
      try {
        final product = await apiService.getProductDetail(event.productId);
        emit(ProductDetailLoaded(product));
      } catch (e) {
        emit(ProductDetailError(e.toString()));
      }
    });
  }
}
