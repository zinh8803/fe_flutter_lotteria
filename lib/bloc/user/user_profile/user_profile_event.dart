abstract class UserProfileEvent {}

class FetchUserProfileEvent extends UserProfileEvent {}

class UpdateUserProfile extends UserProfileEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;

  UpdateUserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });
}

class LogoutEvent extends UserProfileEvent {}
