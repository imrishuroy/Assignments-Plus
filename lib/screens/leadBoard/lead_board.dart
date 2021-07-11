import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/repositories/profile/profile_repository.dart';
import 'package:flutter_todo/widgets/display_image.dart';
import 'package:flutter_todo/widgets/loading_indicator.dart';

class LeadBoard extends StatelessWidget {
  LeadBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _profileRepo = context.read<ProfileRepository>();
    return Expanded(
      child: Column(
        children: [
          const SizedBox(
            width: 200.0,
            child: Divider(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 18.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LeadBoard',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              const Icon(
                Icons.leaderboard,
                color: Colors.green,
              ),
            ],
          ),
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
                            leading: SizedBox(
                              height: 32.0,
                              width: 32.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child:
                                    DisplayImage(user?.imageUrl ?? errorImage),
                              ),
                            ),
                            title: Text(
                              '${index + 1}. ${user?.name}',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            trailing:
                                Text('${leadBoard.values.toList()[index]}'),
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
