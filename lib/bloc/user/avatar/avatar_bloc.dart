import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/data/services/user/api_service.dart';
import 'avatar_event.dart';
import 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  final ApiService apiService;

  AvatarBloc(this.apiService) : super(AvatarInitial()) {
    on<UpdateAvatar>(_onUpdateAvatar);
  }

  Future<void> _onUpdateAvatar(
      UpdateAvatar event, Emitter<AvatarState> emit) async {
    emit(AvatarUpdating());
    try {
      final avatarUrl = await apiService.updateAvatar(event.filePath);
      emit(AvatarUpdated(avatarUrl));
    } catch (e) {
      emit(AvatarUpdateFailure(e.toString()));
    }
  }
}
