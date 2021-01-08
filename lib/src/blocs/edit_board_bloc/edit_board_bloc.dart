import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_board_event.dart';
part 'edit_board_state.dart';

class EditBoardBlocBloc extends Bloc<EditBoardEvent, EditBoardBlocState> {
  String bgColor;
  File pickedImage;
  EditBoardBlocBloc() : super(EditBoardBlocInitial());

  @override
  Stream<EditBoardBlocState> mapEventToState(
    EditBoardEvent event,
  ) async* {
    if (event is SetBoardBgColor) {
      bgColor = event.bgColor;
      yield BoardSettingEdited(bgColor: bgColor, pickedImage: pickedImage);
    }
    if (event is SetBoardCover) {
      pickedImage = event.pickedImage;
      yield BoardSettingEdited(bgColor: bgColor, pickedImage: pickedImage);
    }
  }
}
