import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/auth/auth_bloc.dart';

import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/repositories/services/firebase_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
        //   await auth.signOut();
        // Navigator.of(context)
        //     .pushAndRemoveUntil(AuthWrapper.route(), (route) => false);

        authBloc.add(AuthLogoutRequested());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthRepository>();

    final services =
        RepositoryProvider.of<FirebaseServices>(context, listen: false);
    print(services.leadBoardUsers());

    return StreamBuilder<AppUser?>(
      stream: auth.currentUser.asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('No data found :('),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.0),
                Center(
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage:
                        CachedNetworkImageProvider(snapshot.data!.imageUrl!),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${snapshot.data!.name}',
                      style: TextStyle(
                        fontSize: 17.0,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      _signOutUser(context);
                    },
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                  ),
                ),
                SizedBox(height: 20.0)

                // SizedBox(height: 60.0),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: Text(
                //     'LeadBoard',
                //     style: TextStyle(
                //       fontSize: 23.0,
                //       fontWeight: FontWeight.w600,
                //       letterSpacing: 1.2,
                //     ),
                //   ),
                // ),
                // LeadBoardWidget(),
              ],
            );
          },
        );
      },
    );
  }
}
