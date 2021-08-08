import 'package:assignments/screens/activities/bloc/activities_bloc.dart';
import 'package:assignments/screens/public-todo/public_todos.details.dart';
import 'package:assignments/widgets/centered_text.dart';
import 'package:assignments/widgets/display_image.dart';
import 'package:flutter/material.dart';
import 'package:assignments/extensions/datetime_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitiesScreen extends StatelessWidget {
  ActivitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 14.0, 10.0),
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<ActivitiesBloc, ActivitiesState>(
              listener: (context, state) {
                print(state);
              },
              builder: (context, state) {
                switch (state.status) {
                  case ActivityStatus.error:
                    return CenteredText(text: state.failure.message);

                  case ActivityStatus.succuss:
                    return ListView.builder(
                      itemCount: state.activities.length,
                      itemBuilder: (context, index) {
                        final activity = state.activities[index];
                        final name = activity?.fromUser?.name?.split(' ')[0];
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PublicTodoDetailsScreen(
                                        id: activity?.todo?.todoId),
                                  ),
                                );
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: DisplayImage(
                                  width: 55,
                                  imageUrl: activity?.fromUser?.imageUrl,
                                ),
                              ),
                              title: Text(
                                '$name has posted',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Text(
                                '${activity?.todo?.title}',
                                style: TextStyle(
                                  fontSize: 15.5,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '${activity?.dateTime?.timeAgo()}',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
