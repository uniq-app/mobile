part of 'search_boards_bloc.dart';

abstract class SearchBoardsState extends Equatable {
  const SearchBoardsState();

  @override
  List<Object> get props => [];
}

class SearchBoardInitial extends SearchBoardsState {}

class SearchForBoardsLoading extends SearchBoardsState {}

class SearchForBoardsSuccess extends SearchBoardsState {
  final BoardResults boardResults;
  SearchForBoardsSuccess({@required this.boardResults});
}

class SearchForBoardsNotFound extends SearchBoardsState {}

class SearchForBoardsError extends SearchBoardsState {
  final error;
  SearchForBoardsError({@required this.error});
}
