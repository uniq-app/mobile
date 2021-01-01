import 'package:equatable/equatable.dart';
import 'package:uniq/src/models/cover.dart';

class Board extends Equatable {
  String _id;
  String _name;
  String _description;
  String _creatorId;
  bool _isPrivate;
  bool _isCreatorHidden;
  DateTime _createdAt;
  Cover _cover;

  Board.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['boardId'] ?? '';
    _name = parsedJson['name'] ?? '';
    _description = parsedJson['description'] ?? '';
    _creatorId = parsedJson['u'] ?? '';
    _isPrivate = parsedJson['isPrivate'] ?? false;
    _isCreatorHidden = parsedJson['isCreatorHidden'] ?? false;
    _createdAt = (parsedJson['timestamp'] != null)
        ? DateTime.parse(parsedJson['timestamp'])
        : DateTime.now();
    _cover = new Cover.fromJson(parsedJson['cover']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['creatorId'] = _creatorId;
    data['isPrivate'] = _isPrivate;
    data['isCreatorHidden'] = _isCreatorHidden;
    data['createdAt'] = _createdAt;
    data['cover'] = _cover.toJson();
    return data;
  }

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get creatorId => _creatorId;
  bool get isPrivate => _isPrivate;
  bool get isCreatorHidden => _isCreatorHidden;
  DateTime get createdAt => _createdAt;
  Cover get cover => _cover;

  @override
  List<Object> get props => [
        _id,
        _name,
        _description,
        _creatorId,
        _isPrivate,
        _isCreatorHidden,
        _createdAt,
        _cover
      ];
}
