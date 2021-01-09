import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';

abstract class BoardRepository {
  Future<BoardResults> getBoards();

  Future postBoard(Board board);

  Future putBoard(Board board);

  Future deleteBoard(String boardId);

  Future<List<Photo>> getBoardPhotos(String boardId);

  Future<dynamic> putPhotos(List<String> photos, String boardId);

  Future searchForBoards(String query);
  Future getFollowedBoards();
  Future followBoard(String boardId);
  Future unfollowBoard(String boardId);
}
