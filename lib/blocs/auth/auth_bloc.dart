import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../utils/storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<SignupRequested>(_onSignup);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await AuthService.login(event.email, event.password);
      if (token != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError("Invalid credentials"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignup(SignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await AuthService.signup(event.email, event.password);
      if (token != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError("Signup failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await AppStorage.clear();
    emit(AuthInitial());
  }
}
