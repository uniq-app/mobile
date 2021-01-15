import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/board/board_states.dart';
import 'package:uniq/src/blocs/drag_listener/drag_listener_cubit.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/photo/photo_states.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/grid_element.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:reorderables/reorderables.dart';
import 'package:uniq/src/shared/components/new_element_button.dart';

class BoardGridPage extends StatefulWidget {
  final Board board;

  BoardGridPage({Key key, @required this.board}) : super(key: key);

  @override
  _BoardGridPageState createState() => _BoardGridPageState(this.board);
}

class _BoardGridPageState extends State<BoardGridPage>
    with SingleTickerProviderStateMixin {
  Board board;
  bool isDragging = true;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  _BoardGridPageState(this.board);

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    /* 
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 100),
    ).animate(_controller);
    */
  }

  Color darken(Color color, percent) {
    var f = 1 - percent / 100;
    return Color.fromARGB(color.alpha, (color.red * f).round(),
        (color.green * f).round(), (color.blue * f).round());
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (board.extraData != '')
          ? HexColor.fromHex(board.extraData)
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: (board.extraData != '')
            ? darken(HexColor.fromHex(board.extraData), 15)
            : Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.board.name,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: BlocProvider<DragListenerCubit>(
        create: (context) => DragListenerCubit(),
        child: _body(),
      ),
    );
  }

  _loadPhotos() async {
    context.read<PhotoBloc>().add(FetchBoardPhotos(boardId: board.id));
  }

  Future<List<Image>> _precacheImages(List<Photo> photos) async {
    String src = "${PhotoApiProvider.apiUrl}/thumbnail";
    List<Image> images = photos
        .map((e) => Image.network(
              "$src/${e.value}",
              fit: BoxFit.contain,
            ))
        .toList();
    var futures =
        images.map((element) => precacheImage(element.image, context));
    await Future.wait(futures);
    return images;
  }

  //TODO: To display when board is empty:
  /*
  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.height * 0.25,
          child: SvgPicture.asset('assets/images/blank_canvas.svg'),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          'add some photos to fill this space up',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    ),
  */

  Widget _body() {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (BuildContext context, PhotoState state) {
        print("State: $state");
        if (state is PhotosError) {
          final error = state.error;
          return CustomError(
            message: '${error?.message}.\nTap to retry.',
            onTap: _loadPhotos,
          );
        } else if (state is PhotosLoaded) {
          // Future Builder
          return FutureBuilder(
            future: _precacheImages(state.photos),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Size size = MediaQuery.of(context).size;
                return WrapGrid(state.photos, snapshot.data, size, board);
              } else if (snapshot.hasError) {
                return CustomError(message: "Couldnt preload images");
              }
              return Loading();
            },
          );
        }
        return Center(
          child: Loading(),
        );
      },
    );
  }
}

class WrapGrid extends StatefulWidget {
  final List<Photo> photos;
  final List<Image> precachedImages;
  final Size _size;
  final Board board;

  WrapGrid(this.photos, this.precachedImages, this._size, this.board);
  @override
  _WrapGridState createState() => _WrapGridState();
}

class _WrapGridState extends State<WrapGrid> {
  List<Widget> _tiles = new List();
  bool blockAction = false;

  @override
  void initState() {
    super.initState();
    _createTilesFromImages();
    print("Photos: ${widget.photos.length}");
  }

  _saveReorderChanges() async {
    context.read<BoardBloc>().add(
        ReorderBoardPhotos(boardId: widget.board.id, newPhotos: widget.photos));
  }

  _createTilesFromImages() {
    for (int i = 0; i < widget.precachedImages.length; i++) {
      if (widget.photos[i] != null) {
        print("Photo: ${widget.photos[i].toJson()}");
        _tiles.add(
          GridElement(
            width: widget._size.width * 0.31,
            photo: widget.photos[i],
            image: widget.precachedImages[i],
          ),
        );
      }
    }
  }

  _reorderElements() {
    for (int i = 0; i < widget.photos.length; i++) {
      widget.photos[i].order = i;
    }
  }

  _setIsDragging(bool isDragging) {
    context.read<DragListenerCubit>().setIsDragging(isDragging);
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (!blockAction) {
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        Photo reorderedPhoto = widget.photos.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
        widget.photos.insert(newIndex, reorderedPhoto);
      });
      _reorderElements();
      _saveReorderChanges();
    }
    _setIsDragging(false);
  }

  _deletePhoto(int index) {
    // Remove from arrays
    _tiles.removeAt(index);
    widget.photos.removeAt(index);
    // Notify backend
    context.read<BoardBloc>().add(
          DeleteBoardPhoto(
            photo: widget.photos[index],
            boardId: widget.board.id,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardBloc, BoardState>(
      listener: (context, BoardState state) {
        if (state is DeleteBoardPhotoSuccess ||
            state is DeleteBoardPhotoError) {
          blockAction = false;
        }
      },
      child: ReorderableWrap(
        spacing: 2.0,
        runSpacing: 2.0,
        header: BlocBuilder<DragListenerCubit, bool>(
          builder: (context, bool state) {
            if (state) {
              return DragTarget<int>(
                builder: (context, _, x) => Column(
                  children: [
                    Container(
                      height: 60,
                      child: Center(
                        child: Icon(Icons.delete),
                      ),
                    ),
                    Divider(),
                  ],
                ),
                onAccept: _deletePhoto,
                onMove: (_) => blockAction = true,
                onLeave: (_) => blockAction = false,
              );
            } else
              return Divider();
          },
        ),
        padding: const EdgeInsets.all(8),
        children: _tiles,
        onReorder: _onReorder,
        onNoReorder: (int index) {
          // Set is dragging to show delete zone
          _setIsDragging(false);
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index: $index');
        },
        onReorderStarted: (int index) {
          // Set is dragging to show delete zone
          _setIsDragging(true);
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder started: index: $index');
        },
      ),
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
