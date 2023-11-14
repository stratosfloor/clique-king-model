import 'dart:io';

import 'package:clique_king_model/clique_king_model.dart';
import 'package:clique_king_model/src/models/clique.dart';
import 'package:clique_king_model/src/models/user.dart';
import 'package:clique_king_model/src/repositories/clique_repository.dart';
import 'package:firedart/firedart.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  String? apiKey = env['FIREBASE_API_KEY'];
  String? projectId = env['FIREBASE_PROJECT_ID'];

  if (apiKey == null) {
    print("FIREBASE_API_KEY missing from .env file");
    exit(0);
  }

  if (projectId == null) {
    print("FIREBASE_PROJECT_ID missing from .env file");
    exit(0);
  }

  FirebaseAuth.initialize(
      apiKey, await HiveStore.create(path: Directory.current.path));

  Firestore.initialize(projectId);

  final auth = AuthenticationRepository(auth: FirebaseAuth.instance);
  final userrepo = UserRepository(store: Firestore.instance);
  final clique = CliqueRepository(store: Firestore.instance);

  final userid =
      await auth.loginFirebaseAuth(email: 'test@tt.com', password: '123qwe');
  // print('USERID:');
  // print(userid);
  print('-----------------');

  // final cliq = Clique.onCreate(name: 'Falconpodden');
  // print('Clique');
  // print(cliq.toString());
  // print('---------------------');

  // final user = await userrepo.read(id: userid);
  // final falc = await clique.create(name: 'Umeååå', user: user);
  // print('Create');
  // print(falc.toString());
  // print('---------------------');

  final list = await clique.list();
  print('List: ');
  print(list);
  print('---------------------');

  final exists = await clique.exists(name: 'Falconpodden');
  print('Exists: ');
  print(exists);
  print('---------------------');

  final docid = await clique.getDocumentid(name: 'Falconpodden');
  print('Document id: ');
  print(docid);
  print('---------------------');

  final read = await clique.read(id: 'e20b545b-8cb7-4eb8-bc9e-a168424a124d');
  print('Read: ');
  print(read);
  print('---------------------');

  print('LIST SCORES');
  final listscores = await clique.listScores(docid: docid);
  print(listscores.toString());
  print('---------------------');

  // print('GET SCOREDOCUMENT ID');
  // final scoreid = await clique.getScoreDocumentId(
  //     cliqueId: "VhCmZrmMZqDbGftefrS3", userId: 'Karl');
  // print(scoreid);
  // print('---------------------');

  print('UPDATE SCORE');
  await clique.updateScores(
      cliqueId: 'OLxGfLeF7utm1ytfjs5x', userId: 'Jan', score: 4);

  // print('Add SCORE');
  // final score =
  //     await clique.addScore(docId: docid, userId: 'Lasse', username: 'Kongo');
  // // print(score.toString());
  // print('---------------------');

  exit(255);
}
