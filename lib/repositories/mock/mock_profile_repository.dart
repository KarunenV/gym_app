import '../../mock_data/profiles.dart';
import '../../models/profile.dart';
import '../base/profile_repository.dart';


class MockProfileRepository implements ProfileRepository {

  final List<Profile> _profiles = List.from(profiles);

  @override
  List<Profile> getProfiles() {
    return _profiles;
  }

  @override
  Profile getProfileById(String id) {
    return _profiles.firstWhere((profile) => profile.id == id);
  }

  @override
  void updateProfile(Profile profile) {
    final index = _profiles.indexWhere((item) => item.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
    }
  }
}