import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
part 'taken_images_state.dart';

class TakenImagesCubit extends Cubit<List<File>> {
  TakenImagesCubit() : super(new List<File>());

  void storeTakenImages(List<File> images) {
    emit(images);
  }
}
