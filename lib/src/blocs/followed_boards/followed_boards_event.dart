part of 'followed_boards_bloc.dart';

abstract class FollowedBoardsEvent extends Equatable {
  const FollowedBoardsEvent();

  @override
  List<Object> get props => [];
}

class FollowBoard extends FollowedBoardsEvent {
  final String boardId;
  FollowBoard({@required this.boardId});
}

class UnfollowBoard extends FollowedBoardsEvent {
  final String boardId;
  UnfollowBoard({@required this.boardId});
}

class GetFollowedBoards extends FollowedBoardsEvent {}
