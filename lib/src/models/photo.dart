class Photo {
  String _photoId;
  String _boardId;
  String _value;

  Photo.fromJson(Map<String, dynamic> parsedJson) {
    _photoId = parsedJson['photo_id'] ?? "";
    _boardId = parsedJson['board'] ?? "";
    _value = parsedJson['value'] ?? "";
  }

  String get photoId => _photoId;
  String get boardId => _boardId;
  String get value => _value;
}
