import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uniq/src/blocs/board/board_bloc.dart';
import 'package:uniq/src/blocs/board/board_events.dart';
import 'package:uniq/src/blocs/photo/photo_bloc.dart';
import 'package:uniq/src/blocs/photo/photo_events.dart';
import 'package:uniq/src/blocs/picked_images/picked_images_cubit.dart';
import 'package:uniq/src/blocs/select_board_dialog/select_board_cubit.dart';
import 'package:uniq/src/repositories/photo_repository.dart';
import 'package:uniq/src/services/image_service.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/services/select_board_dialog_service.dart';
import 'package:uniq/src/shared/clickable_add_something.dart';

class ImageLibraryPage extends StatefulWidget {
  @override
  _ImageLibraryPageState createState() => new _ImageLibraryPageState();
}

class _ImageLibraryPageState extends State<ImageLibraryPage> {
  //List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  PhotoRepository photoRepo = PhotoApiProvider();
  SelectBoardDialogService dialogService;
  ImageService imageService;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PickedImagesCubit>(context).storePickedImages([]);
    dialogService = new SelectBoardDialogService(
        context: context, onSubmit: _postAllPhotos);
    imageService = new ImageService(context, mounted);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Pick images'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: onFabPressed,
        child: Icon(Icons.navigate_next),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Center(child: Text('Error: $_error')),
        Expanded(
          child: buildGridView(),
        )
      ],
    );
  }

  Widget buildGridView() {
    return BlocBuilder<PickedImagesCubit, List<Asset>>(
      builder: (BuildContext context, List<Asset> state) {
        List<Asset> images = state;
        print("Rebuilding grid view with: $state");
        return Padding(
          padding: EdgeInsets.all(4),
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            children: [
              ClickableAddSomething(imageService.loadAssets),
              ...List.generate(
                images.length,
                (index) {
                  Asset asset = images[index];
                  return AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  onFabPressed() async {
    List<Asset> images = imageService.images;
    if (images.length > 0) {
      dialogService.showCustomDialog();
    } else {
      print(images.length);
    }
  }

  _postAllPhotos() async {
    List<Asset> images = imageService.images;
    // Read checked cubit then pass to function
    var selectedBoard = await context.read<SelectBoardCubit>().state;
    context
        .read<PhotoBloc>()
        .add(PostAllPhotos(images: images, checked: [selectedBoard]));
  }

  _loadBoards() async {
    context.read<BoardBloc>().add(FetchBoards());
  }
}
