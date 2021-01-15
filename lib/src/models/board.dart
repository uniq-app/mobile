import 'package:equatable/equatable.dart';
import 'package:uniq/src/models/cover.dart';

class Board extends Equatable {
  String _id;
  String _name;
  String _description;
  String _creatorId;
  bool _isPrivate;
  DateTime _createdAt;
  String _cover;
  String _extraData;

  Board.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['boardId'] ?? '';
    _name = parsedJson['name'] ?? '';
    _description = parsedJson['description'] ?? '';
    _creatorId = parsedJson['userId'] ?? '';
    _isPrivate = parsedJson['isPrivate'] ?? false;
    _createdAt = (parsedJson['timestamp'] != null)
        ? DateTime.parse(parsedJson['timestamp'])
        : DateTime.now();
    _cover = parsedJson['cover'] ?? '';
    _extraData = parsedJson['extraData'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['creatorId'] = _creatorId;
    data['isPrivate'] = _isPrivate;
    data['cover'] = _cover;
    data['extraData'] = _extraData;
    return data;
  }

  Map<String, dynamic> toJsonWithoutCover() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['creatorId'] = _creatorId;
    data['isPrivate'] = _isPrivate;
    data['extraData'] = _extraData;
    return data;
  }

  set cover(String cover) => _cover = cover;

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get creatorId => _creatorId;
  bool get isPrivate => _isPrivate;
  DateTime get createdAt => _createdAt;
  String get cover => _cover;
  String get extraData => _extraData;

  @override
  List<Object> get props => [
        _id,
        _name,
        _description,
        _creatorId,
        _isPrivate,
        _createdAt,
        _cover,
        _extraData
      ];
}
