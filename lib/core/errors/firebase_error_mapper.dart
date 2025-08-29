import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseErrorMapper {
  static String toMessage(Object error) {
    if (error is FirebaseAuthException) {
      debugPrint('Error code: ${error.code}');
      switch (error.code) {
        case 'user-not-found':
          return "User not found";
        case 'wrong-password':
          return "Invalid password";
        case 'email-already-in-use':
          return "Email already in use";
        case 'invalid-email':
          return "Invalid email";
        case 'weak-password':
          return "Weak password";
        case 'invalid-credential':
          return "Invalid email or password";
        default:
          return error.message ?? "Unexpected error: $error";
      }
    }

    // You can extend this for other error types (network, Firestore, etc.)
    if (error is FormatException) {
      return "Invalid data format";
    }

    return "Unexpected error: $error";
  }
}
