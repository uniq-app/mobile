import 'package:bloc/bloc.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageState.homePage);

  setPage(PageState state) {
    emit(state);
  }
}
