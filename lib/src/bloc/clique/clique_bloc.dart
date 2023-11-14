import 'package:bloc/bloc.dart';
import 'package:clique_king_model/clique_king_model.dart';
import 'package:clique_king_model/src/models/clique.dart';
import 'package:clique_king_model/src/models/score.dart';
import 'package:clique_king_model/src/models/user.dart';
import 'package:clique_king_model/src/repositories/clique_repository.dart';
import 'package:meta/meta.dart';

/*
  EVENTS 
*/
@immutable
sealed class CliqueEvent {}

final class CliqueLoad extends CliqueEvent {
  final String id;

  CliqueLoad({required this.id});
}

final class CliqueIncreaseScore extends CliqueEvent {
  final String cliqueId;
  final String userId;
  final int score;

  CliqueIncreaseScore({
    required this.cliqueId,
    required this.userId,
    required this.score,
  });
}

/*
  STATES
*/

@immutable
sealed class CliqueState {}

final class CliqueInitial extends CliqueState {}

final class CliqueLoadingInProgress extends CliqueState {}

final class CliqueLoadingSuccess extends CliqueState {
  final Clique clique;
  final List<Score> scores;

  CliqueLoadingSuccess({required this.clique, required this.scores});
}

final class CliqueLoadingFailure extends CliqueState {}

final class CliqueBloc extends Bloc<CliqueEvent, CliqueState> {
  final UserRepository _userRepo; // passed in so it can be easily mocked
  final CliqueRepository _cliqueRepo; // passed in so it can be easily mocked

  CliqueBloc({
    required UserRepository userRepository,
    required CliqueRepository cliqueRepository,
  })  : _userRepo = userRepository,
        _cliqueRepo = cliqueRepository,
        super(CliqueInitial()) {
    on<CliqueEvent>(
      (event, emit) async {
        switch (event) {
          case CliqueLoad():
            emit(CliqueLoadingInProgress());
            try {
              final clique = await cliqueRepository.read(id: event.id);
              final documentid =
                  await cliqueRepository.getDocumentid(name: clique.name);
              final scores =
                  await cliqueRepository.listScores(docid: documentid);
              emit(CliqueLoadingSuccess(clique: clique, scores: scores));
            } on Exception catch (e) {
              print(e);
              emit(CliqueLoadingFailure());
            }

          case CliqueIncreaseScore():
            final oldScore = await _cliqueRepo.getScore(
                docid: event.cliqueId, userId: event.userId);
            final newScore = oldScore.score + event.score;

            _cliqueRepo.updateScores(
                cliqueId: event.cliqueId,
                userId: event.userId,
                score: newScore);
        }
      },
    );
  }
}
