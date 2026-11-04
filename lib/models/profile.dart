import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String id;
  final String name;
  final bool isActive;

  const Profile({
    required this.id,
    required this.name,
    this.isActive = false,
  });

  Map<String, dynamic> toMap() => {'name': name, 'isActive': isActive};

  factory Profile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Profile(
      id: doc.id,
      name: data['name'] as String,
      // Missing field = freshly seeded doc, so default to ticked.
      isActive: (data['isActive'] as bool?) ?? true,
    );
  }
}