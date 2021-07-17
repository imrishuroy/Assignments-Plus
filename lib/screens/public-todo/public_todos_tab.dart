import 'package:assignments/screens/leadBoard/lead_board.dart';
import 'package:assignments/screens/public-todo/public_todos.dart';
import 'package:flutter/material.dart';

class PublicTodosTab extends StatelessWidget {
  const PublicTodosTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 41.0),
            child: Text('Public'),
          ),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            // unselectedLabelStyle: TextStyle(fontSize: 14.0),
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.today_sharp),
                  const SizedBox(width: 10.0),
                  Text(
                    'Todos',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.leaderboard),
                  const SizedBox(width: 10.0),
                  Text(
                    'LeadBoard',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PublicTodos(),
            LeadBoard(),
          ],
        ),
      ),
    );
  }
}
