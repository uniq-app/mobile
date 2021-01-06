import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/picked_images/picked_images_cubit.dart';
import 'package:uniq/src/blocs/select_board_dialog/select_board_cubit.dart';
import 'package:uniq/src/blocs/taken_images/taken_images_cubit.dart';
import 'package:uniq/src/services/select_board_dialog_service.dart';
import 'package:uniq/src/shared/components/new_element_button.dart';

// A screen that allows users to take a picture using a given camera.
class TakePhotoScreen extends StatefulWidget {
  @override
  TakePhotoScreenState createState() => TakePhotoScreenState();
}

class TakePhotoScreenState extends State<TakePhotoScreen> {
  List<File> _images = new List();
  List<File> get images => _images;
  final picker = ImagePicker();
  SelectBoardDialogService dialogService;

  @override
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TakenImagesCubit>(context).storeTakenImages([]);
    dialogService = new SelectBoardDialogService(
        context: context, onSubmit: _postAllPhotos, onError: _loadBoards);
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _images.add(File(pickedFile.path));

      BlocProvider.of<TakenImagesCubit>(context)
          .storeTakenImages(List.from(_images));
    }
  }

  onFabPressed() async {
    if (images.length > 0) {
      dialogService.showCustomDialog();
    } else {
      print(images.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Take a photo.'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: onFabPressed,
        tooltip: 'Take Image',
        child: Icon(Icons.navigate_next),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: buildGridView(),
        )
      ],
    );
  }

  Widget buildGridView() {
    return BlocBuilder<TakenImagesCubit, List<File>>(
      builder: (BuildContext context, List<File> state) {
        List<File> images = state;
        print("Rebuilding grid view with: $state");
        return Padding(
          padding: EdgeInsets.all(4),
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            children: [
              NewElementButton(
                push: _getImage,
                child: Icon(
                  Icons.add_a_photo,
                  color: Theme.of(context).accentColor,
                ),
              ),
              ...List.generate(
                images.length,
                (index) {
                  return Image.file(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _loadBoards() async {
    context.read<BoardBloc>().add(FetchBoards());
  }

  _postAllPhotos() async {
    // Read checked cubit then pass to function
    var selectedBoard = await context.read<SelectBoardCubit>().state;
    context
        .read<PhotoBloc>()
        .add(PostAllFromCamera(images: images, checked: [selectedBoard]));
  }
}
