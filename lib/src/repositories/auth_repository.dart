abstract class AuthRepository {
  Future login(String email, String password);
  Future register(String username, String email, String password);
  Future logout();
}
