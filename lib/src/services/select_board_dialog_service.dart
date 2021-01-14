import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/blocs/select_board_dialog/select_board_cubit.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';

class SelectBoardDialogService {
  final BuildContext context;
  final Function onSubmit;
  final Function onError;
  SelectBoardDialogService({this.context, this.onSubmit, this.onError});

  showCustomDialog() => showDialog(
        context: context,
        barrierDismissible: false,
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
              return buildDialog(context, boards: boards, boardsError: error);
            },
          );
        },
      );

  Widget buildDialog(BuildContext context,
      {List<Board> boards, String boardsError}) {
    return AlertDialog(
      title: Text('Select boards'),
      content: SingleChildScrollView(
        child: BlocConsumer<PhotoBloc, PhotoState>(
          listener: (context, state) {
            if (state is PhotosPostedSuccess) {
              showToast(
                "Successfuly added photos!",
                position: ToastPosition.bottom,
                backgroundColor: Colors.greenAccent,
              );
              Navigator.pop(context, true);
            } else if (state is PhotosError) {
              print("State error instance: ${state.error}");
              showToast(
                "Failed to add photos - ${state.error?.message}",
                position: ToastPosition.bottom,
                backgroundColor: Colors.redAccent,
              );
            }
          },
          builder: (BuildContext context, PhotoState state) {
            print("Rebuilded dialog (photo) current state: $state");
            if (boardsError != null) {
              return CustomError(
                message: "$boardsError.\nTap to retry.",
                onTap: onError,
              );
            } else if (state is PhotosLoading) {
              return Loading();
            }
            return (boards != null)
                ? _dialogContainer(boards, context)
                : CustomError(message: boardsError);
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
                    value: e.id,
                    groupValue: selectedBoard.id,
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
