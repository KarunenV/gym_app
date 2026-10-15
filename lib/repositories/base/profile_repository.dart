import '../../models/profile.dart';

abstract class ProfileRepository {
  List<Profile> getProfiles();

  Profile getProfileById(String id);

  void updateProfile(Profile profile);
}