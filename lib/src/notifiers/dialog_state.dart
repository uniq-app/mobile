import 'package:flutter/foundation.dart';
import 'package:uniq/src/models/board.dart';

class DialogState with ChangeNotifier {
  List<Board> _boards = new List();
  List<Board> _checked = new List();

  List<Board> get boards => _boards;
  List<Board> get checked => _checked;

  DialogState.fromStream(this._boards);

  bool isChecked(Board board) => _checked.contains(board);

  void toggleChecked(Board board) {
    if (_checked.contains(board)) {
      _checked.remove(board);
    } else {
      _checked.add(board);
    }
    notifyListeners();
  }
}
