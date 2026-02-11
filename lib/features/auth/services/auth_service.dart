import '../models/user.dart';
import '../models/auth_models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isInitialized = false;
  User? _currentUser;

  bool get isInitialized => _isInitialized;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> dispose() async {
    _currentUser = null;
    _isInitialized = false;
  }

  Future<User?> login(LoginRequest request) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (request.email == 'user@example.com' && request.password == 'password123') {
        _currentUser = User(
          id: '1',
          email: request.email,
          name: 'Usuario de Ejemplo',
          createdAt: DateTime.now(),
        );
        return _currentUser;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<User?> register(RegisterRequest request) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: request.email,
        name: request.name,
        phone: request.phone,
        createdAt: DateTime.now(),
      );
      
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentUser = null;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> updateProfile(User updatedUser) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = updatedUser.copyWith(updatedAt: DateTime.now());
      return _currentUser;
    } catch (e) {
      return null;
    }
  }
}