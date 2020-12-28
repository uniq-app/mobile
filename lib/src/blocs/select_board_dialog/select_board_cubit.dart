import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniq/src/models/board.dart';

part 'select_board_state.dart';

class SelectBoardCubit extends Cubit<Board> {
  SelectBoardCubit() : super(null);

  void selectBoard(Board board) {
    emit(board);
  }
}
