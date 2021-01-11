import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/shared/components/input_form_field.dart';
import 'package:uniq/src/shared/utilities.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/blocs/profile/profile_bloc.dart';
import 'package:uniq/src/blocs/profile/profile_event.dart';
import 'package:uniq/src/blocs/profile/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String profileCover;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController bioController = new TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  _deleteProfile() {
    //Redirect to security code and profile deletion
    print("Delete profile!!!");
  }

  _updateProfile() {
    print("Update profile!!!");
  }

  Future _getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        profileCover = image.path;
        print(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final _editProfileKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is PutProfileDetailsSuccess) {
                Navigator.pop(context);
                showToast(
                  "Profile successfuly updated!",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.green,
                );
              } else if (state is PutProfileDetailsError) {
                showToast(
                  "Failed to update board - ${state.error.message}",
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _editProfileKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit profile",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        IconButton(
                            iconSize: 35,
                            icon: Icon(Icons.delete_forever),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  child: DeleteAlert(
                                      deleteMessage:
                                          "Are you sure to delete your profile?",
                                      deleteAction: _deleteProfile));
                            })
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "name",
                      controller: nameController,
                      maxLength: 20,
                      validator: (value) {
                        if (value.isEmpty) return 'Enter name of the board';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "bio",
                      controller: bioController,
                      maxLines: null,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Enter description of the board';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    /*if (boardCover != null)
                        BoardCoverSettings(
                          image: boardCover,
                          editLink: _getImage,
                        )
                      else if (widget.board.cover != '')
                        BoardCoverSettings(
                          image:
                              "${PhotoApiProvider.apiUrl}/thumbnail/${widget.board.cover}",
                          editLink: _getImage,
                        )
                      else
                        BoardCoverSettings(
                          editLink: _getImage,
                        ),*/
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UniqButton(
                          screenWidth: 0.35,
                          screenHeight: 0.07,
                          color: Theme.of(context).accentColor,
                          push: () {
                            if (_editProfileKey.currentState.validate()) {
                              _updateProfile();
                            }
                          },
                          text: "Save",
                        ),
                        UniqButton(
                          screenWidth: 0.35,
                          screenHeight: 0.07,
                          color: Theme.of(context).accentColor,
                          push: () {
                            Navigator.pop(context);
                          },
                          text: "Cancel",
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
