import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/shared/components/input_form_field.dart';
import 'package:uniq/src/shared/utilities.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/blocs/profile/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  //TODO: Add profile data
  const EditProfilePage({
    Key key,
    /*this.profile*/
  }) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String profileCover;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController bioController = new TextEditingController();
  bool got = false;
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
    if (nameController.text != null && nameController.text != '') {
      var data = new Map<String, dynamic>();
      data['username'] = nameController.text;
      print(data);
      context.read<ProfileBloc>().add(PutProfileDetails(data: data));
    }
  }

  _getData() {
    if (this.got != true) {
      nameController.text = "Placeholder name"; //widget.profile.name;
      bioController.text = "Placeholder bio"; //widget.profile.bio;
      this.got = true;
    }
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
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, ProfileState state) {
        if (state is PutProfileDetailsSuccess) {
          Navigator.pop(context);
          showToast(
            "Profile successfuly updated!",
            position: ToastPosition.bottom,
            backgroundColor: Colors.green,
          );
        } else if (state is PutProfileDetailsError) {
          showToast(
            "${state.error.message}",
            position: ToastPosition.bottom,
            backgroundColor: Colors.redAccent,
          );
        }
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Center(
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
                          "edit profile",
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
                    SizedBox(height: size.height * 0.02),
                    Container(
                      height: size.height * 0.3,
                      child:
                          SvgPicture.asset("assets/images/polaroid_photo.svg"),
                    ),
                    SizedBox(height: size.height * 0.03),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "name",
                      controller: nameController,
                      maxLength: 15,
                      validator: (value) {
                        if (value.isEmpty) return 'Enter name of the board';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.01),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "bio",
                      controller: bioController,
                      maxLines: null,
                      validator: (value) {
                        if (value.isEmpty) return null;
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
                          color: Theme.of(context).primaryColor,
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
