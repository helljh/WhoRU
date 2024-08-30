import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screen/auth/vo/vo_user_profile.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null) {
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final auth = FirebaseAuth.instance;
    final fdb = FirebaseFirestore.instance;

    try {
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        final doc = await fdb.collection('users').doc(uid).get();
        if (doc.exists) {
          state = UserProfile.fromMap(doc.data()!, doc.id);
        }
      }
    } catch (e) {
      // Handle errors if needed
      print('Error loading user profile: $e');
    }
  }

  void setUserProfile(UserProfile profile) {
    state = profile;
  }

  void clearUserProfile() {
    state = null;
  }
}
