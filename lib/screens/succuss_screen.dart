import 'package:flutter/material.dart';

import 'package:flutter_todo/screens/add_todo_page.dart';

class SuccussScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // RepositoryProvider.of<AuthRepository>(context).signOut();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Succuss'),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddTodoScreen(),
                  ),
                );
              },
              child: Text('Todo Page'),
            )
          ],
        ),
      ),
    );
  }
}
