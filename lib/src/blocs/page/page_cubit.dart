import 'package:bloc/bloc.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  List<PageState> pageStack = List.from([PageState.homePage]);
  PageCubit() : super(PageState.homePage);

  setPage(PageState state) {
    if (!pageStack.contains(state)) pageStack.add(state);
    emit(state);
  }

  popOne() {
    if (pageStack.length > 0) {
      pageStack.removeLast();
      emit(pageStack.last);
    }
  }
}
