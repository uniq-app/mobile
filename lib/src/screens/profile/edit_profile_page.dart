import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uniq/src/blocs/user/user_bloc.dart';
import 'package:uniq/src/models/profile_details.dart';
import 'package:uniq/src/shared/components/input_form_field.dart';
import 'package:uniq/src/shared/components/loading.dart';
import 'package:uniq/src/shared/components/uniq_alert.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/blocs/profile/profile_bloc.dart';
import 'package:uniq/src/shared/components/uniq_button.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  const EditProfilePage({
    Key key,
    this.username,
  }) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String profileCover;

  final TextEditingController nameController = new TextEditingController();
  bool got = false;

  @override
  void initState() {
    super.initState();
    _getUserProfileDetails();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  _deleteProfile() {
    //Redirect to security code and profile deletion
    print("Delete profile!!!");
  }

  _updateProfile() {
    if (nameController.text != null && nameController.text != '') {
      context
          .read<UserBloc>()
          .add(UpdateUsername(username: nameController.text));
    }
  }

  _getUserProfileDetails() {
    nameController.text = widget.username;
  }

  final _editProfileKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //_getData();
    Size size = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, UserState state) {
        if (state is UpdateUsernameSuccess) {
          context.read<ProfileBloc>().add(GetProfileDetails());
          Navigator.pop(context);
          showToast(
            "Profile successfuly updated!",
            position: ToastPosition.bottom,
            backgroundColor: Colors.green,
          );
        } else if (state is UpdateUsernameError) {
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
                    SizedBox(height: size.height * 0.02),
                    Container(
                      height: size.height * 0.3,
                      child:
                          SvgPicture.asset("assets/images/polaroid_photo.svg"),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "edit name",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(height: size.height * 0.03),
                    UniqInputField(
                      cursorColor: Theme.of(context).accentColor,
                      isObscure: false,
                      labelText: "name",
                      controller: nameController,
                      maxLength: 15,
                      validator: (value) {
                        if (value.isEmpty) return 'enter your name';
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UpdateUsernameLoading) {
                          return Loading();
                        }
                        return UniqButton(
                          color: Theme.of(context).buttonColor,
                          push: () {
                            if (_editProfileKey.currentState.validate()) {
                              _updateProfile();
                            }
                          },
                          text: "change",
                        );
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                child: UniqAlert(
                                    message:
                                        "are you sure to delete your profile?",
                                    action: _deleteProfile));
                          },
                          child: Text(
                            "delete profile",
                            style: TextStyle(color: Colors.redAccent),
                          ),
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
