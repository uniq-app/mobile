abstract class AuthRepository {
  Future login(String username, String password);
  Future register(String ownerId);
  Future logout(String ownerId);
}
