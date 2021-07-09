import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/auth/auth_bloc.dart';
import 'package:flutter_todo/blocs/profile/profile_bloc.dart';
import 'package:flutter_todo/models/app_user_model.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // final _nameController = TextEditingController();

  // final _aboutController = TextEditingController();

  bool _editting = false;

  String? _name;
  String? _about;

  _editProfile(AppUser appUser) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BlocProvider.of<ProfileBloc>(context).add(
        UpdateProfile(
          appUser.copyWith(
            name: _name,
            about: _about,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileInitial) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is ProfileLoaded) {
        // _nameController.text = state.appUser.name ?? '';
        // _aboutController.text = state.appUser.about ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.0),
                Center(
                  child: CircleAvatar(
                    radius: 65.0,
                    backgroundImage:
                        NetworkImage(state.appUser.imageUrl ?? errorImage),
                  ),
                ),
                // SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_editting) {
                          _editProfile(state.appUser);
                          setState(() {
                            _editting = false;
                          });
                        } else {
                          setState(() {
                            _editting = !_editting;
                          });
                        }
                      },
                      icon: Icon(
                        _editting ? Icons.check : Icons.edit_outlined,
                        size: 20.0,
                      ),
                    )
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200.0,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'About can\'t be empty' : null,
                            onSaved: (value) => _name = value,
                            // controller: _nameController,
                            initialValue: state.appUser.name,
                            textAlign: TextAlign.center,
                            enabled: _editting,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              border: !_editting ? InputBorder.none : null,
                              // focusedBorder: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: _editting ? 20.0 : 0.0),
                        TextFormField(
                          initialValue: state.appUser.about ?? '',
                          validator: (value) =>
                              value!.isEmpty ? 'About can\'t be empty' : null,
                          onSaved: (value) => _about = value,
                          //controller: _aboutController,
                          enabled: _editting,
                          maxLength: 100,
                          minLines: 1,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Tell us something about you',
                            disabledBorder: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.0),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Text(
                //   '${state.appUser.name}',
                //   style: TextStyle(
                //     fontSize: 19.0,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                // SizedBox(height: 8.0),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 22.0),
                //   child: Text(
                //     '${state.appUser.about}',
                //     style: TextStyle(
                //       fontSize: 14.0,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                //  ),
              ],
            ),
          ),
        );
      }

      return Text('');
    });
  }

  Future _signOutUser(BuildContext context) async {
    //  final auth = context.read<AuthRepository>();

    final authBloc = context.read<AuthBloc>();
    try {
      var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('SignOut'),
            content: Text('Do you want to signOut ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );

      final bool logout = await result ?? false;
      if (logout) {
        authBloc.add(AuthLogoutRequested());
      }
    } catch (error) {
      print(error.toString());
    }
  }
}

const String errorImage =
    'https://developers.google.com/maps/documentation/maps-static/images/error-image-generic.png';
