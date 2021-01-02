import 'package:bloc/bloc.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageState.homePage);

  setPage(int index) {
    print(PageState.values[index]);
    emit(PageState.values[index]);
  }
}
