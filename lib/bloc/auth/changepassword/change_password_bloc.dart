import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/auth/changepassword/change_password_event.dart';
import 'package:frontend_appflowershop/bloc/auth/changepassword/change_password_state.dart';
import 'package:frontend_appflowershop/data/services/user/api_service.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ApiService apiService;
  final PreferenceService preferenceService;

  ChangePasswordBloc(this.apiService, this.preferenceService)
      : super(ChangePasswordInitial()) {
    on<ChangePasswordRequested>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        await apiService.changePassword(
          newPassword: event.newPassword,
        );

        emit(ChangePasswordSuccess());
      } catch (e) {
        emit(ChangePasswordFailure(e.toString()));
      }
    });
  }
}
