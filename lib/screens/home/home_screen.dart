import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/todo/firebase_todo_repository.dart';
import '../add_todo_page.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => HomeScreen(),
    );
  }

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddTodoScreen.routeName);
          //  RepositoryProvider.of<TodosRepository>(context).addNewTodo();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Your Todos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('todos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('sometihig went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              final String todo = snapshot.data?.docs[index]['todo'];
              print('IDS ${snapshot.data?.docs[index].id}');
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$todo',
                  style: TextStyle(fontSize: 18.0),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
