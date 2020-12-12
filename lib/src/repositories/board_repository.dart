import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/services/board_api_provider.dart';

class BoardRepository {
  final BoardApiProvider _boardApiProvider = BoardApiProvider();

  Future<BoardResults> getBoards(String ownerId) =>
      _boardApiProvider.getBoards(ownerId);

  Future<List<Photo>> getPhotos(String boardId) =>
      _boardApiProvider.getPhotos(boardId);
}
