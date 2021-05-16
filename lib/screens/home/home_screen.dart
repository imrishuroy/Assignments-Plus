import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/models/todo.dart';

import '../../repository/todo/firebase_todo_repository.dart';
import '../add_todo_page.dart';

// class HomeScreen extends StatelessWidget {
//   static const String routeName = '/home';

//   static Route route() {
//     return MaterialPageRoute(
//       settings: RouteSettings(name: routeName),
//       builder: (_) => HomeScreen(),
//     );
//   }

//   final CollectionReference usersRef =
//       FirebaseFirestore.instance.collection('users');

//   @override
//   Widget build(BuildContext context) {
//     final todosRepo = RepositoryProvider.of<TodosRepository>(context);
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pushNamed(AddTodoScreen.routeName);
//           //  RepositoryProvider.of<TodosRepository>(context).addNewTodo();
//         },
//         child: Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Your Todos'),
//       ),
//       body: StreamBuilder<List<Todo>>(
//         stream: todosRepo.todos(),
//         //  usersRef
//         //     .doc(FirebaseAuth.instance.currentUser?.uid)
//         //     .collection('todos')
//         //     .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('sometihig went wrong'));
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return ListView.builder(
//             // itemCount: snapshot.data?.docs.length,
//             itemCount: snapshot.data?.length,
//             itemBuilder: (context, index) {
//               // final String todo = snapshot.data?.docs[index]['todo'];
//               final String todo = snapshot.data![index].todo;
//               // print('IDS ${snapshot.data?.docs[index].id}');
//               print('IDS ${snapshot.data?[index].id}');
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   '$todo',
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  BlocProvider.of<TodosBloc>(context).add(LoadTodos());

    return BlocBuilder<TodosBloc, TodosState>(builder: (context, state) {
      if (state is TodosLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TodosLoaded) {
        final List<Todo> todo = state.todos;
        print('${todo.length}');
        return Scaffold(
          appBar: AppBar(
            title: Text('Your Todos'),
          ),
          body: SizedBox(
            height: 300,
            child: ListView.builder(
                itemCount: todo.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${todo[index].todo}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  );
                }),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
