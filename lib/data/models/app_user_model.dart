import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? avatarUrl;
  final String? role;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.avatarUrl,
    this.role,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      role: json['role'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'role': role,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }
}
