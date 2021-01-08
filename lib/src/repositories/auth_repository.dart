abstract class AuthRepository {
  Future login(String email, String password, String fcmToken);
  Future register(String username, String email, String password);
  Future activate(String code);
  Future logout();
}
