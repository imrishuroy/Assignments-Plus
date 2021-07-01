import 'package:flutter/material.dart';
import 'package:flutter_todo/screens/add_edit_todo_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class GetSharedText extends StatelessWidget {
  const GetSharedText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: ReceiveSharingIntent.getInitialText(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          String? text = snapshot.data;
          if (text != null) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context).pushNamed(AddEditScreen.routeName);
            });
          }
          return Center(
            child: Text('${snapshot.data}'),
          );
        },
      ),
    );
  }
}
