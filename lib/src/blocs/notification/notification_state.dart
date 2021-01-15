part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class UpdateFcmLoading extends NotificationState {}

class UpdateFcmSuccess extends NotificationState {}

class UpdateFcmError extends NotificationState {
  final error;
  UpdateFcmError({@required this.error});
}
