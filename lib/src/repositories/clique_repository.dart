import 'package:clique_king_model/src/models/clique.dart';
import 'package:clique_king_model/src/models/score.dart';
import 'package:clique_king_model/src/models/user.dart';
import 'package:firedart/firedart.dart';
import 'package:meta/meta.dart';

@immutable
final class CliqueRepository {
  final Firestore store; // pass it in so it can be mocked.
  final CollectionReference cliquesRef;

  CliqueRepository({
    required this.store,
  }) : cliquesRef = store.collection('cliques');

  Future<Clique> create({
    required String name,
    required User user,
  }) async {
    final clique = Clique.onCreate(name: name);
    try {
      if (!await exists(name: name)) {
        // Add Clique document
        final document = await cliquesRef.add(clique.toMap());
        final score = Score(
          userId: user.id,
          username: user.name,
        );
        final list = await cliquesRef
            .document(document.id)
            .collection('scores')
            .add(score.toMap());
        return Clique.fromMap(document.map);
      } else {
        return Future.error('Name already exists');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Clique> read({required String id}) async {
    try {
      final query = await cliquesRef.where('id', isEqualTo: id).get();
      // Ony one should exists
      return Clique.fromMap(query.first.map);
    } catch (e) {
      return Future.error('error');
    }
  }

  Future<Clique> update({required Clique clique}) async {
    try {
      if (await exists(name: clique.name)) {
        final id = await getDocumentid(name: clique.name);
        await cliquesRef.document(id).update(clique.toMap());
        return clique;
      }
      return Future.error('Something went wrong');
    } catch (e) {
      return Future.error('Something went wrong');
    }
  }

  Future<bool> delete({required String id}) async {
    try {
      if (await cliquesRef.document(id).exists) {
        await cliquesRef.document(id).delete();
        return true;
      }
    } catch (e) {
      return Future.error('Something went wrong');
    }
    return false;
  }

  Future<List<Clique>> list() async {
    try {
      final cliques = await cliquesRef.get();
      return cliques.map((doc) => Clique.fromMap(doc.map)).toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  // Checks if a Clique with @name exists
  // returns document id
  Future<bool> exists({required String name}) async {
    try {
      final query = await cliquesRef.where("name", isEqualTo: name).get();
      if (query.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return Future.error('Something went wrong');
    }
  }

  Future<String> getDocumentid({required String name}) async {
    try {
      final query = await cliquesRef.where("name", isEqualTo: name).get();
      if (query.isNotEmpty) {
        return query.first.id;
      }
      return Future.error('Not found');
    } catch (e) {
      return Future.error('Something went wrong');
    }
  }
  /*
    Score collections
  */

  Future<void> addScore({
    required String docId,
    required String userId,
    required String username,
  }) async {
    final score = Score(userId: userId, username: username);
    print('doc');
    final doc = await cliquesRef
        .document(docId)
        .collection('scores')
        .add(score.toMap());
    print(doc.toString());
  }

  Future<List<Score>> listScores({
    required String docid,
  }) async {
    try {
      final docs = await cliquesRef.document(docid).collection('scores').get();
      return docs.map((doc) => Score.fromMap(doc.map)).toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String> getScoreDocumentId({
    required String cliqueId,
    required String userId,
  }) async {
    try {
      final query = await cliquesRef
          .document(cliqueId)
          .collection('scores')
          .where("userId", isEqualTo: userId)
          .get();
      if (query.isNotEmpty) {
        return query.first.id;
      }
    } catch (e) {
      return Future.error(e);
    }
    return Future.error('Something went wrong');
  }

  Future<void> updateScores({
    required String cliqueId,
    required String userId,
    required int score,
  }) async {
    try {
      final scoreDocId =
          await getScoreDocumentId(cliqueId: cliqueId, userId: userId);
      await cliquesRef
          .document(cliqueId)
          .collection('scores')
          .document(scoreDocId)
          .update({'score': score});
    } catch (e) {
      Future.error(e);
    }
  }
}
