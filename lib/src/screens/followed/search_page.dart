import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniq/src/blocs/search_boards/search_boards_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/services/board_api_provider.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/input_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/others_board_list.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Color white = Colors.white;
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
                automaticallyImplyLeading: false,
                title: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Theme.of(context).primaryColorLight,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      cursorColor: white,
                      onEditingComplete: () {
                        context
                            .read<SearchBoardsBloc>()
                            .add(SearchForBoards(query: queryController.text));
                      },
                      controller: queryController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'tap to search',
                          icon: Icon(
                            Icons.search,
                            color: white,
                          ),
                          hintStyle: Theme.of(context).textTheme.subtitle1),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
                pinned: true,
                toolbarHeight: size.height * 0.081,
                expandedHeight: size.height * 0.081,
                collapsedHeight: size.height * 0.083,
              ),
              BlocBuilder<SearchBoardsBloc, SearchBoardsState>(
                builder: (BuildContext context, SearchBoardsState state) {
                  if (state is SearchForBoardsLoading) {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Loading(),
                              ])
                        ],
                      ),
                    );
                  } else if (state is SearchForBoardsSuccess) {
                    final List<Board> boards = state.boardResults.results;
                    return OthersBoardList(boards);
                  } else if (state is SearchForBoardsNotFound) {
                    return SliverFillRemaining(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height * 0.2,
                              child: SvgPicture.asset(
                                  'assets/images/not_found.svg'),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              'nothing have been found',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ]),
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
                    return SliverFillRemaining(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height * 0.2,
                              child: SvgPicture.asset(
                                  'assets/images/searching.svg'),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              'search for inspiration',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ]),
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
