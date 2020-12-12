// Result by calling Get /boards/ownerId - Returning pagination metadata with List of owned boards

import 'package:uniq/src/models/board.dart';

class BoardResults {
  // Add "pageable later"
  List<Board> _results = new List();

  BoardResults.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson['content'] != null) {
      parsedJson['content']
          .forEach((result) => _results.add(Board.fromJson(result)));
    } else {
      _results = [];
    }
  }

  List<Board> get results => _results;
}
