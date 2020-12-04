import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/repositories/board_repository.dart';

class BoardBloc {
  final BoardRepository boardRepository = BoardRepository();
  // Stream for boards results
  final _boardSubject = PublishSubject<BoardResults>();

  Observable<BoardResults> get boardResults => _boardSubject.stream;

  getBoards(String ownerId) async {
    BoardResults boardResults = await boardRepository.getBoards(ownerId);
    _boardSubject.sink.add(boardResults);
  }

  // Prevent leaks by closing stream (Dunno where should use it tho)
  dispose() {
    _boardSubject.close();
  }
}

final bloc = BoardBloc();
