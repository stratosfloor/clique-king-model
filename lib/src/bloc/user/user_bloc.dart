import 'package:bloc/bloc.dart';
import 'package:clique_king_model/clique_king_model.dart';
import 'package:clique_king_model/src/models/user.dart';
import 'package:firedart/auth/exceptions.dart';
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

final class UserLoginFailure extends UserState {
  @override
  List<Object?> get props => [];
}

final class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepo;
  final AuthenticationRepository _authRepo;

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
            if (await _authRepo.isSignedIn()) {
              final userId = await _authRepo.getUserId();
              final user = await _userRepo.read(id: userId);
              emit(UserLoginSuccess(user: user));
            }
            emit(UserLoginInProgress());

          case UserLogin():
            try {
              final userId = await _authRepo.loginFirebaseAuth(
                  email: event.email, password: event.password);
              if (await _userRepo.store.document(userId).exists) {
                final user = await _userRepo.read(id: userId);
                emit(UserLoginSuccess(user: user));
              }
            } catch (e) {
              print(e);
              emit(UserLoginFailure());
            }
            emit(UserLoginFailure());

          case UserRegister():
            try {
              final authUser = await _authRepo.createFirebaseAuth(
                  email: event.email, password: event.password);
              if (await _authRepo.isSignedIn()) {
                final user =
                    await _userRepo.create(name: event.name, id: authUser.id);
                emit(UserRegisterSuccess(user: user));
              }
            } catch (e) {
              emit(UserRegisterFailure());
            }
            emit(UserRegisterFailure());

          case UserLogout():
            if (await _authRepo.isSignedIn()) {
              _authRepo.logoutFirebaseAuth();
              emit(UserInitial());
            }
          case UserDelete():
            if (await _authRepo.isSignedIn()) {
              final userId = await _authRepo.getUserId();
              _userRepo.delete(id: userId);
              _authRepo.delete();
              emit(UserInitial());
            }
        }
      },
    );
  }
}
