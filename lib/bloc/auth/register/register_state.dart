import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/user.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final UserModel user;
  RegisterSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);
  @override
  List<Object?> get props => [error];
}
