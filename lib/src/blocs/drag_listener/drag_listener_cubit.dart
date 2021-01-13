import 'package:bloc/bloc.dart';

class DragListenerCubit extends Cubit<bool> {
  DragListenerCubit() : super(false);

  setIsDragging(bool isDragging) {
    emit(isDragging);
  }
}
