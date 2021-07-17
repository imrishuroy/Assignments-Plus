import 'package:assignments/models/app_user_model.dart';
import 'package:assignments/repositories/profile/profile_repository.dart';
import 'package:assignments/widgets/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeadBoard extends StatelessWidget {
  LeadBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _profileRepo = context.read<ProfileRepository>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Column(
        children: [
          SizedBox(height: 15.0),
          Expanded(
            child: FutureBuilder<Map<String, int>>(
              future: _profileRepo.leadBoard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingIndicator();
                }
                final Map<String, int>? leadBoard = snapshot.data;
                if (leadBoard != null) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<AppUser?>(
                        future: _profileRepo
                            .getUser(leadBoard.keys.toList()[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingIndicator();
                          }
                          final user = snapshot.data;
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                              child: CachedNetworkImage(
                                height: 50.0,
                                width: 50.0,
                                imageUrl: user?.imageUrl ?? errorImage,
                              ),
                            ),
                            title: Text(
                              '${index + 1}. ${user?.name}',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            trailing: Text(
                              '${leadBoard.values.toList()[index]}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

const String errorImage =
    'https://developers.google.com/maps/documentation/maps-static/images/error-image-generic.png';
