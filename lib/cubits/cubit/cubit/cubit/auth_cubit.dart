import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manger/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  AuthCubit(this.authService) : super(AuthInitial());
  Future<void> logIn(String email, String password) async {
    emit(AuthLoading());
    final result = await authService.login(email: email, password: password);
    if (result == null) {
      emit(AuthSuccess());
    } else {
      emit(AuthFaluire(errorMessage: result));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    final result = await authService.register(
      email: email,
      password: password,
      name: name,
    );
    if (result == null) {
      emit(AuthSuccess());
    } else {
      emit(AuthFaluire(errorMessage: result));
    }
  }
}
