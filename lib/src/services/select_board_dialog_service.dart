import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/custom_error.dart';
import 'package:uniq/src/shared/loading.dart';

class SelectBoardDialogService {
  final BuildContext context;
  final Function onSubmit;
  final Function onError;
  SelectBoardDialogService({this.context, this.onSubmit, this.onError});

  showCustomDialog() => showDialog(
        context: context,
        builder: (context) {
          return BlocBuilder<BoardBloc, BoardState>(
            builder: (BuildContext context, BoardState state) {
              print("Rebuilded Dialog");
              String error;
              List<Board> boards;
              if (state is BoardsError) {
                error = state.error.message;
              } else if (state is BoardsLoaded) {
                boards = state.boardResults.results;
              }
              if (state is BoardsLoading) {
                return Center(
                  child: Loading(),
                );
              }
              return buildDialog(context, boards: boards, error: error);
            },
          );
        },
      );

  Widget buildDialog(BuildContext context, {List<Board> boards, String error}) {
    return AlertDialog(
      title: Text('Select baords'),
      content: SingleChildScrollView(
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (BuildContext context, PhotoState state) {
            print("Rebuilded dialog (photo)");
            if (state is PhotosError) {
              final error = state.error.message;
              return CustomError(
                message: '$error.\nTap to retry.',
              );
            } else if (state is PhotoInitial) {
              return (boards != null)
                  ? _dialogContainer(boards, context)
                  : CustomError(message: error);
            } else if (state is PhotosPostedSuccess) {
              Navigator.pop(context, true);
            }
            return Loading();
          },
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go back'),
            ),
            FlatButton(
              onPressed: () => {
                // Send to backend
                onSubmit(),
              },
              child: Text('Add'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dialogContainer(List<Board> boards, BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...boards
              .map(
                (e) => CheckboxListTile(
                  title: Text(e.name),
                  onChanged: (value) {
                    context.read<BoardBloc>().add(SelectBoard(board: e));
                  },
                  value: false,
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
