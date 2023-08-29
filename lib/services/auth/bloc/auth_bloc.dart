import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth.state.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // should register
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistring(
        exception: null,
        isLoading: false,
      ));
    });

    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistring(
          exception: e,
          isLoading: false,
        ));
      }
    });

    // initialize
    on<AuthEventInitialize>((event, emit) async {
      provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });

    // log in
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while i log you in');

      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
