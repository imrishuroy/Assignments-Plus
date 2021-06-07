import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = RepositoryProvider.of<AuthRepository>(context, listen: false);

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
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.0),
            Center(
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage:
                    CachedNetworkImageProvider(snapshot.data!.imageUrl!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${snapshot.data!.name}',
                style: TextStyle(
                  fontSize: 17.0,
                  letterSpacing: 1.2,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
