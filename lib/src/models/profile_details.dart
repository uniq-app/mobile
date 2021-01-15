class ProfileDetails {
  String _username;
  bool _notificationsEnabled;

  ProfileDetails.fromJson(Map<String, dynamic> parsedJson) {
    _username = parsedJson['username'];
    _notificationsEnabled = parsedJson['notificationsEnabled'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    if (_username != '') data['username'] = _username;
    if (_notificationsEnabled)
      data['notificationsEnabled'] = _notificationsEnabled;
    return data;
  }

  String get username => _username;
  bool get notificationsEnabled => _notificationsEnabled;
}
