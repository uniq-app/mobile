abstract class ProfileRepository {
  Future getProfileDetails();
  Future putProfileDetails(Map<String, dynamic> data);
}
