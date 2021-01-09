part of 'search_boards_bloc.dart';

abstract class SearchBoardsEvent extends Equatable {
  const SearchBoardsEvent();

  @override
  List<Object> get props => [];
}

class SearchForBoards extends SearchBoardsEvent {
  final String query;
  SearchForBoards({@required this.query});
}
