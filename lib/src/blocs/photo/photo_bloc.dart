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
        yield PhotosError(error: NoInternetException());
      } on HttpException {
        yield PhotosError(error: NoServiceFoundException());
      } on FormatException {
        yield PhotosError(error: InvalidFormatException());
      } catch (e) {
        yield PhotosError(error: e);
      }
    }
    if (event is PostAllPhotos) {
      try {
        yield PhotosLoading();
        var results = await photoRepository.postAll(event.images);
        await boardRepository.putPhotos(results, event.checked.id);
        yield PhotosPostedSuccess();
        await Future.delayed(Duration(milliseconds: 300));
        yield PhotoInitial();
      } on SocketException {
        yield PhotosError(error: NoInternetException());
      } on HttpException {
        yield PhotosError(error: NoServiceFoundException());
      } on FormatException {
        yield PhotosError(error: InvalidFormatException());
      } catch (e) {
        yield PhotosError(error: e);
      }
    }
    if (event is PostAllFromCamera) {
      try {
        yield PhotosLoading();
        var results = await photoRepository.postAllFromCamera(event.images);
        await boardRepository.putPhotos(results, event.checked.id);
        yield PhotosPostedSuccess();
      } on SocketException {
        yield PhotosError(error: NoInternetException());
      } on HttpException {
        yield PhotosError(error: NoServiceFoundException());
      } on FormatException {
        yield PhotosError(error: InvalidFormatException());
      } catch (e) {
        yield PhotosError(error: e);
      }
    }
    if (event is PostCoverImage) {
      try {
        yield PhotosLoading();
        await photoRepository.postImageFromFile(event.image);
        yield PhotosPostedSuccess();
      } on SocketException {
        yield PhotosError(error: NoInternetException());
      } on HttpException {
        yield PhotosError(error: NoServiceFoundException());
      } on FormatException {
        yield PhotosError(error: InvalidFormatException());
      } catch (e) {
        yield PhotosError(error: e);
      }
    }
    if (event is ClearPhotoState) {
      photos = null;
      yield PhotoInitial();
    }
  }
}
