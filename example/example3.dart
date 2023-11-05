import 'dart:io';

import 'package:clique_king_model/clique_king_model.dart';
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
  final store = UserRepository(store: Firestore.instance);

  final bloc = UserBloc(userRepository: store, authenticationRepository: auth);

  print(bloc.state.props);
  print(bloc.state);

  bloc.add(UserStarted());

  print(bloc.state.props);
  print(bloc.state);

  bloc.add(UserLogin(email: 'tester@lester.com', password: 'test123'));

  print(bloc.state.props);
  print(bloc.state);

  exit(255);
}
