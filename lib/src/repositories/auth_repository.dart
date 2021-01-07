abstract class AuthRepository {
  Future login(String username, String password);
  Future register(String username, String email, String password);
  Future activate(String code);
  Future logout();
}
