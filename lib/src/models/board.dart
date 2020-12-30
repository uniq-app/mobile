import 'package:equatable/equatable.dart';

class Board extends Equatable {
  String _id;
  String _name;
  String _creatorId;
  bool _isPrivate;
  bool _isCreatorHidden;
  DateTime _createdAt;
  DateTime _updatedAt;

  Board.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['boardId'] ?? '';
    _name = parsedJson['name'] ?? '';
    _creatorId = parsedJson['creatorId'] ?? '';
    _isPrivate = parsedJson['isPrivate'] ?? false;
    _isCreatorHidden = parsedJson['isCreatorHidden'] ?? false;
    _createdAt = (parsedJson['createdAt'] != null)
        ? DateTime.parse(parsedJson['createdAt'])
        : DateTime.now();
    _updatedAt = (parsedJson['updatedAt'] != null)
        ? DateTime.parse(parsedJson['updatedAt'])
        : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['name'] = _name;
    data['creatorId'] = _creatorId;
    data['isPrivate'] = _isPrivate;
    data['isCreatorHidden'] = _isCreatorHidden;
    data['createdAt'] = _createdAt;
    data['updatedAt'] = _updatedAt;
    return data;
  }

  String get id => _id;
  String get name => _name;
  String get creatorId => _creatorId;
  bool get isPrivate => _isPrivate;
  bool get isCreatorHidden => _isCreatorHidden;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;

  @override
  List<Object> get props => [
        _id,
        _name,
        _creatorId,
        _isPrivate,
        _isCreatorHidden,
        _createdAt,
        _updatedAt
      ];
}
