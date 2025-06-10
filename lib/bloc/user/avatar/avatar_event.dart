abstract class AvatarEvent {}

class UpdateAvatar extends AvatarEvent {
  final String filePath;

  UpdateAvatar(this.filePath);
}
