class Photo {
  String _photoId;
  String _boardId;
  String _value;
  int _order;

  Photo.fromJson(Map<String, dynamic> parsedJson) {
    _photoId = parsedJson['photo_id'] ?? "";
    _boardId = parsedJson['board'] ?? "";
    _value = parsedJson['value'] ?? "";
    _order = parsedJson['order'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = _photoId;
    data['board_id'] = _boardId;
    data['value'] = _value;
    data['order'] = _order;
    return data;
  }

  String get photoId => _photoId;
  String get boardId => _boardId;
  String get value => _value;
  int get order => _order;

  set order(int newOrder) => _order = newOrder;
}
