import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/search_boards/search_boards_bloc.dart';
import 'package:uniq/src/services/board_api_provider.dart';
import 'package:uniq/src/shared/components/board_list.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/input_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/components/loading.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  final queryController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    print("Search page destroy");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
    return BlocProvider<SearchBoardsBloc>(
      create: (context) => SearchBoardsBloc(
        boardRepository: BoardApiProvider(),
      ),
      child: SlideTransition(
        position: _offsetAnimation,
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Search'),
            ),
            body: Column(
              children: [
                UniqInputField(
                  color: Theme.of(context).accentColor,
                  isObscure: false,
                  labelText: "Search",
                  controller: queryController,
                ),
                OutlinedButton(
                  onPressed: () => {
                    if (queryController.text.length > 0)
                      context
                          .read<SearchBoardsBloc>()
                          .add(SearchForBoards(query: queryController.text))
                  },
                  child: Text('Search'),
                ),
                BlocBuilder<SearchBoardsBloc, SearchBoardsState>(
                  builder: (BuildContext context, SearchBoardsState state) {
                    if (state is SearchForBoardsLoading) {
                      return Loading();
                    } else if (state is SearchForBoardsSuccess) {
                      return Text('Found');
                      // TODO: Here
                      //return BoardList(state.boardResults.results);
                    } else if (state is SearchForBoardsNotFound) {
                      return Text('Not found boards matching query');
                    } else if (state is SearchForBoardsError) {
                      return CustomError(
                        message: state.error.message,
                        onTap: () => {},
                      );
                    } else {
                      return Center(
                        child: Text("Search for boards"),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
