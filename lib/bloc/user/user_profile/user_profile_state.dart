import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/user.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserModel user;

  const UserProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserProfileLoggedOut extends UserProfileState {}

class UserDetailUpdating extends UserProfileState {}

class UserDetailUpdateSuccess extends UserProfileState {}

class UserDetailUpdateFailure extends UserProfileState {
  final String error;

  UserDetailUpdateFailure(this.error);
}
