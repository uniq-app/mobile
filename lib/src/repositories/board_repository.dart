import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';

abstract class BoardRepository {
  Future<BoardResults> getBoards(String ownerId);

  Future<List<Photo>> getBoardPhotos(String boardId);

  Future<dynamic> postPhotos(List<String> photos, String boardId);

  Board selectBoard(Board board);
}
