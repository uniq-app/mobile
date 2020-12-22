import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:uniq/src/services/exceptions.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final BoardRepository boardRepository;
  List<Photo> photos;

  PhotoBloc({this.boardRepository}) : super(PhotoInitial());

  @override
  Stream<PhotoState> mapEventToState(PhotoEvent event) async* {
    if (event is FetchBoardPhotos) {
      try {
        yield PhotosLoading();
        photos = await boardRepository.getBoardPhotos(event.boardId);
        yield PhotosLoaded(photos: photos);
      } on SocketException {
        yield PhotosError(error: NoInternetException('No internet'));
      } on HttpException {
        yield PhotosError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield PhotosError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        yield PhotosError(error: NoInternetException('Unknown error'));
      }
    }
  }
}
