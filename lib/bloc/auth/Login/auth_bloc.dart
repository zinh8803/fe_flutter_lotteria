import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/auth/Login/auth_event.dart';
import 'package:frontend_appflowershop/bloc/auth/Login/auth_state.dart';
import 'package:frontend_appflowershop/data/services/user/api_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService api;

  AuthBloc(this.api) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await api.login(event.email, event.password);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
