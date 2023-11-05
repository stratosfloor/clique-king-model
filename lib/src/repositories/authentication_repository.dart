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

  Future<String> loginFirebaseAuth({
    required String email,
    required String password,
  }) async {
    try {
      final user = await auth.signIn(email, password);
      return user.id;
    } on AuthException catch (e) {
      throw Future.error(e.message);
    } catch (e) {
      throw Future.error(e);
    }
  }

  Future<User> getUser() async {
    try {
      if (auth.isSignedIn) {
        return await auth.getUser();
      }
    } catch (e) {
      throw (e.toString());
    }
    return Future.error('error');
  }

  Future<String> getUserId() async {
    try {
      if (auth.isSignedIn) {
        return auth.userId;
      }
    } catch (e) {
      throw (e.toString());
    }
    return Future.error('Something went wrong');
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

  Future<bool> isSignedIn() {
    try {
      if (auth.isSignedIn) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
