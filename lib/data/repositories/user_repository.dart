import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_rent/data/models/app_user_model.dart';

class UserRepository {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(AppUser user) async {
    await usersRef.doc(user.uid).set(user.toJson(), SetOptions(merge: true));
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await usersRef.doc(uid).get();
    if (doc.exists) {
      return AppUser.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Stream<AppUser?> userStream(String uid) {
    return usersRef.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return AppUser.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  Future<void> updateProfile(String uid, {String? name, String? avatarUrl}) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      if (name != null) 'name': name,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    });
  }
}
