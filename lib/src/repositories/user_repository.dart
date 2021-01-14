abstract class UserRepository {
  Future activate(String code);
  Future getCode();
  Future forgotPassword(String email);
  Future updatePassword(String newPassword, oldPassword, repeatedNewPassword);
  Future resendCode(String email);
  Future resetPassword(String email, String password);
  Future updateEmail(String email);
  Future updateUsername(String username);
  Future validCode(String code);
}
