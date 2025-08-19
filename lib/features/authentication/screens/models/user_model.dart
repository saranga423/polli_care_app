import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing user data
class UserModel {
  final String id; // Firestore document ID
  String username;
  final String email;

  /// Constructor
  UserModel({required this.id, required this.username, required this.email});

  /// Empty model
  static UserModel empty() => UserModel(id: '', username: '', email: '');

  /// Convert model to JSON for storing in Firebase
  Map<String, dynamic> toJson() {
    return {'Username': username, 'Email': email};
  }

  /// Create model from Firestore snapshot
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}
