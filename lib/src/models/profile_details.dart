class ProfileDetails {
  String _avatar;
  String _bio;
  String _email;
  String _username;

  ProfileDetails.fromJson(Map<String, dynamic> parsedJson) {
    _avatar = parsedJson['avatar'];
    _bio = parsedJson['bio'];
    _email = parsedJson['email'];
    _username = parsedJson['username'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    if (_avatar != '') data['avatar'] = _avatar;
    if (_bio != '') data['bio'] = _bio;
    if (_email != '') data['email'] = _email;
    if (_username != '') data['username'] = _username;
    return data;
  }

  String get avatar => _avatar;
  String get bio => _bio;
  String get email => _email;
  String get username => _username;
}
