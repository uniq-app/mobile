import 'package:equatable/equatable.dart';

class Cover extends Equatable {
  String _photoId;
  String _boardId;
  String _value;
  Cover.fromJson(Map<String, dynamic> parsedJson) {
    _photoId = parsedJson['photo_id'] ?? '';
    _boardId = parsedJson['board'] ?? '';
    _value = parsedJson['value'] ?? '';
  }

  String get photoId => _photoId;
  String get boardId => _boardId;
  String get value => _value;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = _photoId;
    data['board'] = _boardId;
    data['value'] = _value;
    return data;
  }

  @override
  List<Object> get props => [_photoId, _boardId, _value];
}
