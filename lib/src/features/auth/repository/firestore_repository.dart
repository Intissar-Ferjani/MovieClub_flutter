import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/features/auth/models/app_user.dart';

final firestoreRepositoryProvider = Provider(
  (ref) => FirestoreRepository(),
);

class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<AppUser?> getUser(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();

    if (userDoc.exists) {
      return AppUser.fromJson(userDoc.data()!);
    } else {
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, String name, String email) async {
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'email': email,
    });
  }
}
