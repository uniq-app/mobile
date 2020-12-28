import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/blocs/select_board_dialog/select_board_cubit.dart';
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
              print("Rebuilded Dialog (boards) current state: $state");
              String error;
              List<Board> boards;
              if (state is BoardsError) {
                error = state.error.message;
              } else if (state is BoardsLoaded) {
                boards = state.boardResults.results;
                // Perform one time lookup to fire first board as selected
                BlocProvider.of<SelectBoardCubit>(context)
                    .selectBoard(boards[0]);
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
      title: Text('Select boards'),
      content: SingleChildScrollView(
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (BuildContext context, PhotoState state) {
            print("Rebuilded dialog (photo) current state: $state");
            if (state is PhotosError) {
              final error = state.error.message;
              return CustomError(
                message: '$error.\nTap to retry.',
              );
            } else if (state is PhotoInitial || state is PhotosLoaded) {
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
    return BlocBuilder<SelectBoardCubit, Board>(
      builder: (BuildContext context, Board selectedBoard) => Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...boards
                .map(
                  (e) => RadioListTile(
                    title: Text(e.name),
                    value: e.name,
                    groupValue: selectedBoard.name,
                    selected: selectedBoard == e,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (value) {
                      context.read<SelectBoardCubit>().selectBoard(e);
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
