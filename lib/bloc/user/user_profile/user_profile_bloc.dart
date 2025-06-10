import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/data/services/user/api_service.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';

import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ApiService apiService;
  final PreferenceService preferenceService;

  UserProfileBloc(this.apiService, this.preferenceService)
      : super(UserProfileInitial()) {
    on<FetchUserProfileEvent>((event, emit) async {
      emit(UserProfileLoading());
      try {
        final user = await apiService.getUserProfile();
        emit(UserProfileLoaded(user));
      } catch (e) {
        emit(UserProfileError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(UserProfileLoading());
      try {
        await apiService.logout();
        await PreferenceService.clearToken();
        emit(UserProfileLoggedOut());
      } catch (e) {
        emit(UserProfileError(e.toString()));
      }
    });

    on<UpdateUserProfile>((event, emit) async {
      emit(UserDetailUpdating());

      try {
        await apiService.updateUserProfile(
          name: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber,
          address: event.address,
        );
        final updateuser = await apiService.getUserProfile();
        emit(UserProfileLoaded(updateuser));
      } catch (e) {
        emit(UserDetailUpdateFailure(e.toString()));
      }
    });
  }
}
