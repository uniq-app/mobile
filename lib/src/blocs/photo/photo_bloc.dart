import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/repositories/board_repository.dart';
import 'package:uniq/src/repositories/photo_repository.dart';
import 'package:uniq/src/shared/exceptions.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final BoardRepository boardRepository;
  final PhotoRepository photoRepository;
  List<Photo> photos;

  PhotoBloc({this.boardRepository, this.photoRepository})
      : super(PhotoInitial());

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
    if (event is PostAllPhotos) {
      try {
        yield PhotosLoading();
        var isSuccess =
            await photoRepository.postAll(event.images, event.checked);
        //print("IsSuccess: $isSuccess");
        // Todo: reload photos?
        // Todo: return new custom state?
        yield PhotosPostedSuccess();
        await Future.delayed(Duration(milliseconds: 300));
        yield PhotoInitial();
      } on SocketException {
        yield PhotosError(error: NoInternetException('No internet'));
      } on HttpException {
        yield PhotosError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield PhotosError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield PhotosError(error: e);
      }
    }
    if (event is PostSingleImage) {
      try {
        yield PhotosLoading();
        await photoRepository.postSingleImageToBoards(
            event.image, event.checked);
        yield PhotosPostedSuccess();
      } on SocketException {
        yield PhotosError(error: NoInternetException('No internet'));
      } on HttpException {
        yield PhotosError(error: NoServiceFoundException('No service found'));
      } on FormatException {
        yield PhotosError(
            error: InvalidFormatException('Invalid resposne format'));
      } catch (e) {
        print(e);
        yield PhotosError(error: e);
      }
    }
  }
}
