import 'package:equatable/equatable.dart';

abstract class AvatarState extends Equatable {
  const AvatarState();

  @override
  List<Object> get props => [];
}

class AvatarInitial extends AvatarState {}

class AvatarUpdating extends AvatarState {}

class AvatarUpdated extends AvatarState {
  final String avatarUrl;

  AvatarUpdated(this.avatarUrl);
  @override
  List<Object> get props => [avatarUrl];
}

class AvatarUpdateFailure extends AvatarState {
  final String error;

  AvatarUpdateFailure(this.error);
  @override
  List<Object> get props => [error];
}
