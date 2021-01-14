class Photo {
  String _photoId;
  String _boardId;
  String _value;
  int _order;
  String _extraData;

  Photo.fromJson(Map<String, dynamic> parsedJson) {
    _photoId = parsedJson['photoId'] ?? "";
    _boardId = parsedJson['boardId'] ?? "";
    _value = parsedJson['value'] ?? "";
    _order = parsedJson['order'] ?? 0;
    _extraData = parsedJson['extraData'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['photoId'] = _photoId;
    data['boardId'] = _boardId;
    data['value'] = _value;
    data['order'] = _order;
    data['extraData'] = _extraData;
    return data;
  }

  String get photoId => _photoId;
  String get boardId => _boardId;
  String get value => _value;
  int get order => _order;

  set order(int newOrder) => _order = newOrder;
}
