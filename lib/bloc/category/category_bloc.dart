import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/data/services/Category/api_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ApiService apiService;

  CategoryBloc(this.apiService) : super(CategoryInitial()) {
    on<FetchCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await apiService.getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
    on<AddCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        await apiService.createCategory(
          name: event.name,
          imagePath: event.imagePath,
        );
        final categories = await apiService.getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<UpdateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        await apiService.updateCategory(
          id: event.id,
          name: event.name,
          imagePath: event.imagePath,
          currentImageUrl: event.currentImageUrl,
        );
        final categories = await apiService.getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<DeleteCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        await apiService.deleteCategory(event.id);
        final categories = await apiService.getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
