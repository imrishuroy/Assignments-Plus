import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/services/notification_services.dart';

class NotificationCheck extends StatelessWidget {
  const NotificationCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notification =
        RepositoryProvider.of<NotificationService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Check'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                notification.sheduledNotification(
                  time: DateTime.now().add(Duration(seconds: 5)),
                  channelId: '5',
                  channelName: '5 sec channel',
                  channelDescription: 'this will display notification of 5 sec',
                  id: 0,
                  title: 'Hi there...',
                  message: 'This is 5 sec notification',
                );
              },
              child: Text('Notification - 1'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                notification.sheduledNotification(
                  time: DateTime.now().add(Duration(seconds: 10)),
                  channelId: '10',
                  channelName: '10 sec channel',
                  channelDescription:
                      'this will display notification of 10 sec',
                  id: 1,
                  title: 'Hi there...',
                  message: 'This is 10 sec notification',
                );
              },
              child: Text('Notification - 2'),
            )
          ],
        ),
      ),
    );
  }
}
