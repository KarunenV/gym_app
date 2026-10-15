class Profile {
  final String id;
  final String name;
  final bool isActive;


  const Profile({
    required this.id,
    required this.name,
    this.isActive = false,
  });
}
    