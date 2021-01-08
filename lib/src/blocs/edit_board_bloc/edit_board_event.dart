part of 'edit_board_bloc.dart';

abstract class EditBoardEvent extends Equatable {
  const EditBoardEvent();

  @override
  List<Object> get props => [];
}

abstract class SetBoardCover extends EditBoardEvent {
  final File pickedImage;
  SetBoardCover({this.pickedImage});
}

abstract class SetBoardBgColor extends EditBoardEvent {
  final String bgColor;
  SetBoardBgColor({this.bgColor});
}
