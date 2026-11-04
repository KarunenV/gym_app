import '../../models/profile.dart';

abstract class ProfileRepository {
  Stream<List<Profile>> watchProfiles();

  void setActive(String id, bool isActive);
}