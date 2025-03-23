import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl authRepository;
  late final LoginUseCase loginUseCase;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    loginUseCase = LoginUseCase(repository: authRepository);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.call(event.username, event.password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', user.token);
      emit(AuthSuccess(token: user.token, role: user.role, name: user.name));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
