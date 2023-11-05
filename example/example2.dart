import 'dart:io';

import 'package:clique_king_model/clique_king_model.dart';
import 'package:clique_king_model/src/models/clique.dart';
import 'package:clique_king_model/src/models/user.dart';
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

  // try {
  //   await auth.createFirebaseAuth(email: 'test@tt.com', password: '123qwe');
  // } catch (e) {
  //   print(e);
  // }

  try {
    final userid =
        await auth.loginFirebaseAuth(email: 'test@tt.com', password: '123qwe');
    print('USERID:');
    print(userid);
  } catch (e) {
    print(e);
  }

  FirebaseAuth.instance.signInState.listen((event) {
    print(event);
  });

  final user = await auth.getUserId();

  // final user2 = User(name: user.email!, id: user.id);

  // final doc = await store.create(name: user2.name, id: user2.id);

  final readUser = await userrepo.read(id: user);

  final list = await userrepo.list();

  print('DOCUMENT:');
  // // print(doc.id);
  // print('-----------');
  // print('USER:');
  // print(user);
  // print('-----------');
  print('READ USER:');
  print(readUser);
  // print(fetchedUser.id);
  print('-----------------:');

  print('LIST: ');
  print(list);

  exit(255);
}
