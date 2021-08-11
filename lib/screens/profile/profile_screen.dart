import 'package:assignments/blocs/profile/profile_bloc.dart';
import 'package:assignments/models/app_user_model.dart';
import 'package:assignments/screens/contact/contact_us_screen.dart';
import 'package:assignments/screens/in-app-purchase/in_app_puchase_button.dart';
import 'package:assignments/screens/privacy/privacy_policy.dart';
import 'package:assignments/screens/profile/widgets/logout.dart';
import 'package:assignments/screens/profile/widgets/name_and_about.dart';
import 'package:assignments/screens/profile/widgets/name_and_about_textfileds.dart';
import 'package:assignments/widgets/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:universal_platform/universal_platform.dart';

class ProfileScreen extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        if (state is ProfileInitial) {
          return LoadingIndicator();
        } else if (state is ProfileLoaded) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50.0),
                    CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey.shade200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: CachedNetworkImage(
                          height: 110.0,
                          width: 110.0,
                          fit: BoxFit.cover,
                          imageUrl: state.appUser.imageUrl != null &&
                                  state.appUser.imageUrl!.isNotEmpty
                              ? state.appUser.imageUrl!
                              : errorImage,
                          errorWidget: (context, _, __) {
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
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
                                _aboutController.text =
                                    state.appUser.about ?? '';
                                _editting = !_editting;
                              });
                            }
                          },
                          icon: Icon(
                            _editting ? Icons.check : Icons.edit_outlined,
                            size: _editting ? 25 : 20.0,
                            color: _editting ? Colors.green : Colors.grey,
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
                    const SizedBox(height: 25.0),
                    if (UniversalPlatform.isWeb)
                      ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PrivicyPolicy.routeName);
                        },
                        title: Text('Privacy Policy'),
                        trailing: Icon(Icons.navigate_next_sharp),
                      ),
                    const SizedBox(height: 10.0),
                    if (UniversalPlatform.isWeb)
                      ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ContactUsScreen.routeName);
                        },
                        title: Text('Contact Us'),
                        trailing: Icon(Icons.navigate_next_sharp),
                      ),
                    const SizedBox(height: 200.0),
                    InAppPurchaseButton(),
                    const SizedBox(height: 15.0),
                    const Logout(),
                    const Text(
                      'Made in 🇮🇳 by SixteenBrains,',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        fontSize: 15.0,
                        color: Color(0xffB2B1B9),
                      ),
                    ),
                  ],
                ),
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
