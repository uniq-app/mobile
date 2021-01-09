part of 'followed_boards_bloc.dart';

abstract class FollowedBoardsState extends Equatable {
  const FollowedBoardsState();

  @override
  List<Object> get props => [];
}

class FollowedBoardsInitial extends FollowedBoardsState {}

class FollowBoardLoading extends FollowedBoardsState {}

class FollowBoardSuccess extends FollowedBoardsState {}

class FollowBoardError extends FollowedBoardsState {
  final error;
  FollowBoardError({@required this.error});
}

class UnfollowBoardLoading extends FollowedBoardsState {}

class UnfollowBoardSuccess extends FollowedBoardsState {}

class UnfollowBoardError extends FollowedBoardsState {
  final error;
  UnfollowBoardError({@required this.error});
}

class GetFollowedBoardsLoading extends FollowedBoardsState {}

class GetFollowedBoardsSuccess extends FollowedBoardsState {
  final BoardResults boardResults;
  GetFollowedBoardsSuccess({@required this.boardResults});
}

class GetFollowedBoardsError extends FollowedBoardsState {
  final error;
  GetFollowedBoardsError({@required this.error});
}
