abstract class ChangePasswordEvent {}

class ChangePasswordRequested extends ChangePasswordEvent {
  final String newPassword;

  ChangePasswordRequested({required this.newPassword});
}
