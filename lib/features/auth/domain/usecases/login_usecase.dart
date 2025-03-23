import '../entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LoginUseCase {
  final AuthRepositoryImpl repository;

  LoginUseCase({required this.repository});

  Future<User> call(String username, String password) async {
    // The repository returns token, role, and name.
    final response = await repository.login(username, password);
    return User(
      token: response['token'],
      role: response['role'],
      name: response['name'],
    );
  }
}
