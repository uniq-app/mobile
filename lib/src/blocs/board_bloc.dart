import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/repositories/board_repository.dart';

class BoardBloc {
  final BoardRepository boardRepository = BoardRepository();
  // Stream for boards results
  final _boardSubject = PublishSubject<BoardResults>();
  final _photosSubject = PublishSubject<List<Photo>>();

  Observable<BoardResults> get boardResults => _boardSubject.stream;
  Observable<List<Photo>> get photos => _photosSubject.stream;

  getBoards(String ownerId) async {
    BoardResults boardResults = await boardRepository.getBoards(ownerId);
    _boardSubject.sink.add(boardResults);
  }

  getPhotos(String boardId) async {
    List<Photo> photosResults = await boardRepository.getPhotos(boardId);
    _photosSubject.sink.add(photosResults);
  }

  // Prevent leaks by closing stream (Dunno where should use it tho)
  dispose() {
    print('Bloc disposed');
    _boardSubject.close();
    _photosSubject.close();
  }
}

final bloc = BoardBloc();
