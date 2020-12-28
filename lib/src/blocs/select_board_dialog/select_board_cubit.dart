import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'select_board_state.dart';

class SelectBoardCubit extends Cubit<SelectBoardState> {
  SelectBoardCubit() : super(SelectBoardInitial());
}
