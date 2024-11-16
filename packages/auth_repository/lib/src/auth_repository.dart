// auth_repository.dart
import 'dart:async';
import 'package:dio/dio.dart';

part 'auth_token.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  final _controller = StreamController<AuthStatus>();
  final String baseUrl = 'http://localhost:8888/v1';
  final Dio dio = Dio();
  AuthToken? _currentToken;

  Stream<AuthStatus> get status async* {
    yield AuthStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/account/login/user',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        _currentToken = AuthToken.fromJson(response.data);
        _controller.add(AuthStatus.authenticated);
      } else {
        throw Exception('Failed to log in with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('login error: $e');
      throw Exception('Failed to log in');
    }
  }

  void logout() {
    _currentToken = null;
    _controller.add(AuthStatus.unauthenticated);
  }

  AuthToken? getCurrentToken() {
    return _currentToken;
  }

  void dispose() => _controller.close();
}