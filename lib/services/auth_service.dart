import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'invalid-login-credentials':
          return 'Invalid email or password. Please try again.';
        default:
          return 'Login failed. Please try again later.';
      }
    } catch (e) {
      return 'Something went wrong. Please try again later.';
    }
  }

  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email already in use';
      } else if (e.code == 'weak-password') {
        return ' Password is too weak';
      } else {
        return e.message ?? ' Something went wrong';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
