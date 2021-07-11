import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/auth/auth_bloc.dart';
import 'package:flutter_todo/blocs/profile/profile_bloc.dart';
import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/repositories/profile/profile_repository.dart';

import 'package:flutter_todo/screens/profile/widgets/name_and_about.dart';
import 'package:flutter_todo/screens/profile/widgets/name_and_about_textfileds.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  // static Route route(String userId) {
  //   return MaterialPageRoute(
  //     settings: RouteSettings(name: routeName),
  //     builder: (_) => BlocProvider<ProfileBloc>(
  //       create: (context) => ProfileBloc(
  //         profileRepository: context.read<ProfileRepository>(),
  //         userId: userId,
  //       ),
  //       child: ProfileScreen(),
  //     ),
  //   );
  // }
  static Route route(String userId) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => ProfileScreen(),
    );
  }

  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _aboutController = TextEditingController();

  bool _editting = false;

  Future<void> _editProfile(AppUser appUser) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('About Conutrolller ----- ${_aboutController.text}');
      BlocProvider.of<ProfileBloc>(context).add(
        UpdateProfile(
          appUser.copyWith(
            name: _nameController.text,
            about: _aboutController.text,
          ),
        ),
      );
      setState(() {
        _editting = false;
      });
    }
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signOut(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Do you want to sign out of the app?'),
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
          )
        ],
      ),
    );
    print(result);
    if (result) {
      BlocProvider.of<AuthBloc>(context)..add(AuthLogoutRequested());
      // RepositoryProvider.of<AuthRepository>(context, listen: false).signOut();
      // Navigator.of(context).pushNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        if (state is ProfileInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProfileLoaded) {
          print('profile state is ------- ${state.appUser.uid}');
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.0),
                  Center(
                    child: CircleAvatar(
                      radius: 65.0,
                      //   backgroundImage:
                      // NetworkImage(authRepo.userImage ?? errorImage),
                      backgroundImage: NetworkImage(
                        state.appUser.imageUrl != null &&
                                state.appUser.imageUrl!.isNotEmpty
                            ? state.appUser.imageUrl!
                            : errorImage,
                      ),

                      // state.appUser.imageUrl ?? state.appUser!.imageUrl!.isEmpty!  ? errorImage: errorImage,
                    ),
                  ),
                  // ),
                  // SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_editting) {
                            _editProfile(state.appUser);
                          } else {
                            setState(() {
                              _nameController.text = state.appUser.name ?? '';
                              _aboutController.text = state.appUser.about ?? '';
                              _editting = !_editting;
                            });
                          }
                        },
                        icon: Icon(
                          _editting ? Icons.check : Icons.edit_outlined,
                          size: _editting ? 25 : 20.0,
                          color: _editting ? Colors.green : Colors.black,
                        ),
                      )
                    ],
                  ),

                  !_editting
                      ? NameAndAbout(
                          name: state.appUser.name,
                          about: state.appUser.about,
                        )
                      : NameAndAboutTextFields(
                          isEditing: _editting,
                          nameController: _nameController,
                          aboutController: _aboutController,
                        ),
                  Spacer(),
                  //Logout(),
                  Center(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(primary: Colors.red),
                      onPressed: () => _signOut(context),
                      icon: Icon(Icons.logout),
                      label: Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Text('');
      }),
    );
  }
}

const String errorImage =
    'https://developers.google.com/maps/documentation/maps-static/images/error-image-generic.png';
