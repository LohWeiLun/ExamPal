import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String name;
  final DateTime dateOfBirth;

  const User({
    required this.name,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.dateOfBirth,
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
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "UID": uid,
        "email": email,
        "photoUrl": photoUrl,
        "dob": dateOfBirth,
      };
}
