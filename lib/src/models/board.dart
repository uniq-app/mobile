class Board {
  String _id;
  String _name;
  String _creatorId;
  List<dynamic> _photos;
  bool _isPrivate;
  bool _isCreatorHidden;
  DateTime _createdAt;
  DateTime _updatedAt;

  Board.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'] ?? '';
    _name = parsedJson['name'] ?? '';
    _creatorId = parsedJson['creatorId'] ?? '';
    _photos = parsedJson['photos'] ?? [];
    _isPrivate = parsedJson['isPrivate'] ?? false;
    _isCreatorHidden = parsedJson['isCreatorHidden'] ?? false;
    _createdAt = parsedJson['createdAt']
        ? DateTime.parse(parsedJson['createdAt'])
        : DateTime.now();
    _updatedAt = parsedJson['updatedAt']
        ? DateTime.parse(parsedJson['updatedAt'])
        : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['name'] = _name;
    data['creatorId'] = _creatorId;
    data['photos'] = _photos;
    data['isPrivate'] = _isPrivate;
    data['isCreatorHidden'] = _isCreatorHidden;
    data['createdAt'] = _createdAt;
    data['updatedAt'] = _updatedAt;
    return data;
  }

  String get id => _id;
  String get name => _name;
  String get creatorId => _creatorId;
  List<String> get photos => _photos;
  bool get isPrivate => _isPrivate;
  bool get isCreatorHidden => _isCreatorHidden;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;
}
