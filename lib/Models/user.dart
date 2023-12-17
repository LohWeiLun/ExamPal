import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String name;
  final DateTime dateOfBirth;
  final bool schedule; // New field
  final bool motivation; // New field

  const User({
    required this.name,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.dateOfBirth,
    required this.schedule,
    required this.motivation,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    DateTime dob = snapshot["dob"].toDate();

    return User(
      name: snapshot["name"],
      uid: snapshot["UID"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      dateOfBirth: dob,
      schedule: snapshot["schedule"] ?? true, // Default value if not present
      motivation: snapshot["motivation"] ?? true, // Default value if not present
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "UID": uid,
    "email": email,
    "photoUrl": photoUrl,
    "dob": dateOfBirth,
    "schedule": schedule,
    "motivation": motivation,
  };
}
