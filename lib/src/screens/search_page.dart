import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/search_boards/search_boards_bloc.dart';
import 'package:uniq/src/models/board.dart';
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<SearchBoardsBloc>(
      create: (context) => SearchBoardsBloc(
        boardRepository: BoardApiProvider(),
      ),
      child: Builder(
        builder: (context) => Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Container(
                  child: UniqInputField(
                    textInputAction: TextInputAction.search,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    cursorColor: Colors.white,
                    isObscure: false,
                    labelText: "Search",
                    controller: queryController,
                    onEditingCompleted: () {
                      context
                          .read<SearchBoardsBloc>()
                          .add(SearchForBoards(query: queryController.text));
                    },
                  ),
                ),
                pinned: true,
                expandedHeight: 70.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [],
                  ),
                ),
              ),
              BlocBuilder<SearchBoardsBloc, SearchBoardsState>(
                builder: (BuildContext context, SearchBoardsState state) {
                  if (state is SearchForBoardsLoading) {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Loading(),
                        ],
                      ),
                    );
                  } else if (state is SearchForBoardsSuccess) {
                    final List<Board> boards = state.boardResults.results;
                    return BoardList(boards);
                  } else if (state is SearchForBoardsNotFound) {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Text('Not found boards matching query'),
                        ],
                      ),
                    );
                  } else if (state is SearchForBoardsError) {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          CustomError(
                            message: state.error.message,
                            onTap: () => {},
                          )
                        ],
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Center(
                            child: Text("Search for boards"),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
