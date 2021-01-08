part of 'edit_board_bloc.dart';

abstract class EditBoardBlocState extends Equatable {
  const EditBoardBlocState();

  @override
  List<Object> get props => [];
}

class EditBoardBlocInitial extends EditBoardBlocState {}

class BoardSettingEdited extends EditBoardBlocState {
  final String bgColor;
  final File pickedImage;
  BoardSettingEdited({this.bgColor, this.pickedImage});
}
