import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_crud/productcrud_event.dart';
import 'package:frontend_appflowershop/bloc/product/product_crud/productcrud_state.dart';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:frontend_appflowershop/data/services/Product/api_product.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class ProductcrudBloc extends Bloc<ProductcrudEvent, ProductcrudState> {
  final ApiService_product apiService;

  ProductcrudBloc(this.apiService) : super(ProductInitial()) {
    on<CreateProductEvent>((event, emit) async {
      print('👉 Bắt đầu xử lý CreateProductEvent');
      emit(ProductLoading());
      try {
        if (event.imageFile.path.isNotEmpty) {
          print('📸 Có ảnh: ${event.imageFile.path}');
          await apiService.createProduct(event.product, event.imageFile.path);
          print('✅ Gọi API createProduct xong');
          emit(ProductcrudSuccess());
        } else {
          emit(ProductError("Vui lòng chọn ảnh cho sản phẩm"));
        }
      } catch (e, stack) {
        print(stack);
        emit(ProductError(e.toString()));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await apiService.updateProduct(
            event.product, event.imageFile?.path ?? '');
        ProductcrudLoaded(await apiService.getProducts());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await apiService.deleteProduct(event.productId);
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
