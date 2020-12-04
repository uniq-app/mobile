// Result by calling Get /boards/ownerId - Returning pagination metadata with List of owned boards

import 'package:uniq/src/models/board.dart';

class BoardResults {
  int _count;
  String _next;
  String _previous;
  List<Board> _results = new List();

  BoardResults.fromJson(Map<String, dynamic> parsedJson) {
    _count = parsedJson['count'] ?? 0;
    _next = parsedJson['next'] ?? "";
    _previous = parsedJson['previous'] ?? "";
    if (parsedJson['results'] != null) {
      parsedJson['results']
          .forEach((result) => _results.add(Board.fromJson(result)));
    } else {
      _results = [];
    }
  }

  int get count => _count;
  String get next => _next;
  String get previous => _previous;
  List<Board> get results => _results;
}
