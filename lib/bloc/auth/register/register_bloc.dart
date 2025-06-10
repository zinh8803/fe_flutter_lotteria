import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/auth/register/register_event.dart';
import 'package:frontend_appflowershop/bloc/auth/register/register_state.dart';
import 'package:frontend_appflowershop/data/services/user/api_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ApiService api;

  RegisterBloc(this.api) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        final user = await api.register(
          event.username,
          event.email,
          event.password,
        );
        emit(RegisterSuccess(user));
      } catch (e) {
        emit(RegisterError(e.toString()));
      }
    });
  }
}
