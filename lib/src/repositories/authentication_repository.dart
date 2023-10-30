import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:meta/meta.dart';

@immutable
final class AuthenticationRepository {
  final FirebaseAuth auth; // pass it in so it can be mocked.

  AuthenticationRepository({required this.auth});

  // TODO: Create methods for registration and login using Firebase Authentication.

  Future<User> createFirebaseAuth({
    required String email,
    required String password,
  }) async {
    try {
      return await auth.signUp(email, password);
    } on AuthException catch (e) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User> loginFirebaseAuth({
    required String email,
    required String password,
  }) async {
    try {
      return await auth.signIn(email, password);
    } on AuthException catch (e) {
      return Future.error(e.message);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User> getUser() async {
    try {
      return await auth.getUser();
    } catch (e) {
      throw (e.toString());
    }
  }

  void logoutFirebaseAuth() {
    try {
      if (auth.isSignedIn) {
        auth.signOut();
      }
    } catch (e) {
      print(e);
    }
  }
}
