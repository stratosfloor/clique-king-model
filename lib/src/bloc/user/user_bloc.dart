import 'package:bloc/bloc.dart';
import 'package:clique_king_model/clique_king_model.dart';
import 'package:clique_king_model/src/models/user.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/*
  EVENT
*/

@immutable
sealed class UserEvent {}

final class UserStarted extends UserEvent {}

final class UserRegister extends UserEvent {
  final String email;
  final String password;
  final String name;

  UserRegister({
    required this.email,
    required this.password,
    required this.name,
  });
}

final class UserLogin extends UserEvent {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});
}

final class UserLogout extends UserEvent {}

final class UserDelete extends UserEvent {}

/*
  STATE
*/

@immutable
sealed class UserState extends Equatable {}

final class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

final class UserRegisterInProgess extends UserState {
  @override
  List<Object> get props => [];
}

final class UserRegisterSuccess extends UserState {
  final User user;

  UserRegisterSuccess({required this.user});
  @override
  List<Object> get props => [user];
}

final class UserRegisterFailure extends UserState {
  @override
  List<Object> get props => [];
}

final class UserLoginInProgress extends UserState {
  @override
  List<Object?> get props => [];
}

final class UserLoginSuccess extends UserState {
  final User user;

  UserLoginSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

final class UserLoginSuccess2 extends UserState {
  @override
  List<Object?> get props => [];
}

final class UserLoginFailure extends UserState {
  @override
  List<Object?> get props => [];
}

final class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepo; // passed in so it can be easily mocked
  final AuthenticationRepository
      _authRepo; // passed in so it can be easily mocked

  UserBloc(
      {required UserRepository userRepository,
      required AuthenticationRepository authenticationRepository})
      : _userRepo = userRepository,
        _authRepo = authenticationRepository,
        super(UserInitial()) {
    on<UserEvent>(
      (event, emit) async {
        switch (event) {
          case UserStarted():
            // TODO: Attempt to login using potentially stored local token.

            if (await _authRepo.isSignedIn()) {
              print(await _authRepo.isSignedIn());
              final userId = await _authRepo.getUserId();
              print(_userRepo);
              print(userId);
              //
              //TODO: HÄR BLIR DET FEL
              //
              final user = await _userRepo.read(id: userId);
              // print(user);
              print('6');

              // emit(UserLoginSuccess(user: user));
            }

            emit(UserLoginInProgress());

          case UserLogin():
            // TODO: Handle this case.
            // print(event.email);
            // print(event.password);
            try {
              final userId = await _authRepo.loginFirebaseAuth(
                  email: event.email, password: event.password);
              // print(userId);
              if (await _userRepo.store.document(userId).exists) {
                final user = await _userRepo.read(id: userId);
                print(state.props);
                // emit(UserLoginSuccess(user: user));
              }
            } catch (e) {
              print(e);
            }

            emit(UserLoginFailure());

          case UserRegister():
            emit(UserRegisterInProgess());
          // TODO: Handle this case.
          // if fail emit registerfailre
          // if success emit registersuccess

          case UserLogout():
          // TODO: Handle this case.
          case UserDelete():
          // TODO: Handle this case.
        }
      },
    );
  }
}
