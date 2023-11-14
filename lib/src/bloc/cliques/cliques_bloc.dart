import 'package:bloc/bloc.dart';
import 'package:clique_king_model/clique_king_model.dart';
import 'package:clique_king_model/src/models/clique.dart';
import 'package:clique_king_model/src/models/user.dart';
import 'package:clique_king_model/src/repositories/clique_repository.dart';
import 'package:meta/meta.dart';

/*
  EVENTS
*/

@immutable
sealed class CliquesEvent {}

final class CliquesLoadEvent extends CliquesEvent {}

final class NewCliqueEvent extends CliquesEvent {
  final String name;
  final User user;

  NewCliqueEvent({
    required this.name,
    required this.user,
  });
}

/*
  STATES
*/

@immutable
sealed class CliquesState {}

final class CliquesInitial extends CliquesState {}

final class CliquesLoadingInProgress extends CliquesState {}

final class CliquesLoadingSuccess extends CliquesState {
  final List<Clique> cliques;

  CliquesLoadingSuccess({required this.cliques});
}

final class CliquesLoadingFailure extends CliquesState {}

final class NewCliqueSuccess extends CliquesState {
  final List<Clique> cliques;

  NewCliqueSuccess({
    required this.cliques,
  });
}

final class NewCliqueFailure extends CliquesState {}

final class CliquesBloc extends Bloc<CliquesEvent, CliquesState> {
  final CliqueRepository _cliqueRepo; // passed in so it can be easily mocked

  CliquesBloc({required CliqueRepository cliqueRepository})
      : _cliqueRepo = cliqueRepository,
        super(CliquesInitial()) {
    on<CliquesEvent>(
      (event, emit) async {
        switch (event) {
          case CliquesLoadEvent():
            emit(CliquesLoadingInProgress());
            try {
              final cliques = await _cliqueRepo.list();
              emit(CliquesLoadingSuccess(cliques: cliques));
            } on Exception catch (e) {
              print(e);
              emit(CliquesLoadingFailure());
            }

          case NewCliqueEvent():
            if (await _cliqueRepo.exists(name: event.name)) {
              emit(NewCliqueFailure());
            } else {
              final clique =
                  await _cliqueRepo.create(name: event.name, user: event.user);
              final cliques = await _cliqueRepo.list();
              emit(NewCliqueSuccess(cliques: cliques));
            }
        }
      },
    );
  }
}
