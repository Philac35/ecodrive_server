// Abstract AuthProvider
import '../../Entities/AuthUser.dart';

abstract interface class AbstractAuthProvider {
  Future<void> connect(String email, String password);
  Future<void> disconnect();
  AuthUser? get currentUser;
}