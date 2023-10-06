import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/modals/userModals.dart';

class FirebaseHelper {
  static Future<UserModal?> getUserModalById(String uid) async {
    UserModal? userModal;
    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (docSnap.data() != null) {
      userModal = UserModal.fromMap(docSnap.data() as Map<String, dynamic>);
    }
    return userModal;
  }

  static Future<void> toggleBlockedUser(
    String currentUserId,
    String targetUserId,
  ) async {
    final userRef = FirebaseFirestore.instance.collection('users');
    final currentUserDoc = await userRef.doc(currentUserId).get();
    if (currentUserDoc.exists) {
      // Get the blocked users list
      List<String> blockedUsers = currentUserDoc['blockedUsers'] ?? [];

      if (blockedUsers.contains(targetUserId)) {
        // If the target user is already blocked, unblock them
        blockedUsers.remove(targetUserId);
      } else {
        // If the target user is not blocked, block them
        blockedUsers.add(targetUserId);
      }

      // Update the blocked users list in Firestore
      await userRef.doc(currentUserId).update({'blockedUsers': blockedUsers});
    }
  }
  }

