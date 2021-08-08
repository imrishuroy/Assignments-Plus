import 'package:assignments/enums/enums.dart';
import 'package:assignments/models/activity.dart';
import 'package:assignments/models/app_user_model.dart';

import 'package:assignments/models/public_todos.dart';
import 'package:assignments/widgets/display_image.dart';
import 'package:flutter/material.dart';
import 'package:assignments/extensions/datetime_extension.dart';

class ActivitiesScreen extends StatelessWidget {
  ActivitiesScreen({Key? key}) : super(key: key);

  final List<Activity> activities = [
    Activity(
      id: '1',
      type: ActivityType.newPost,
      fromUser: AppUser.emptyUser.copyWith(
        imageUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80',
        name: 'Rishu Kumar',
      ),
      todo: PublicTodo(
          authorId: '11',
          dateTime: DateTime.now(),
          todoId: 'todo1',
          title:
              'It doesn\'t cost any \$\$ to host your bot, and there\'s nothing you need to install on your machine.In this course Beau helps you build a Discord bot for free w/ JS.',
          todo: 'This is todo'),
      dateTime: DateTime.now(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 14.0, 10.0),

      //.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final name = activity.fromUser?.name?.split(' ')[0];
                return Column(
                  children: [
                    ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: DisplayImage(
                          width: 55,
                          imageUrl: activity.fromUser?.imageUrl,
                        ),
                      ),
                      // title: Text(
                      //   '${activity.todo?.title}',
                      //   style: TextStyle(fontSize: 16.0),
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      // subtitle: Text('${activity.dateTime?.timeAgo()}'),
                      title: Text(
                        '$name has posted',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: 1.5),
                          Text(
                            '${activity.todo?.title}',
                            style: TextStyle(
                              fontSize: 15.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${activity.dateTime?.timeAgo()}',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
