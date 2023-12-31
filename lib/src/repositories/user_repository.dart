import 'package:clique_king_model/src/models/user.dart';
import 'package:firedart/firedart.dart';
import 'package:meta/meta.dart';

@immutable
final class UserRepository {
  final Firestore store;
  final CollectionReference usersRef;

  UserRepository({
    required this.store,
  }) : usersRef = Firestore.instance.collection('users');

  Future<User> create({
    required String name,
    required String id,
  }) async {
    final user = User(name: name, id: id);
    try {
      if (await usersRef.document(id).exists) {
        return Future.error('ID already exists');
      } else {
        final document = await usersRef.document(id).create(user.toMap());
        return User.fromMap(document.map);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User> read({required String id}) async {
    try {
      if (await usersRef.document(id).exists) {
        final user = await usersRef.document(id).get();
        return User.fromMap(user.map);
      } else {
        return Future.error('Id not found');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> update({required User user}) async {
    try {
      if (await usersRef.document(user.id).exists) {
        await Firestore.instance
            .collection("users")
            .document(user.id)
            .update(user.toMap());
        return Future.value(true);
      }
    } catch (e) {
      return Future.error(e);
    }
    return Future.value(false);
  }

  Future<bool> delete({required String id}) async {
    try {
      if (await usersRef.document(id).exists) {
        await usersRef.document(id).delete();
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<User>> list() async {
    try {
      final allDocs = await usersRef.get();
      return allDocs.map((doc) => User.fromMap(doc.map)).toList();
    } catch (e) {
      return Future.error(e);
    }
  }
}
