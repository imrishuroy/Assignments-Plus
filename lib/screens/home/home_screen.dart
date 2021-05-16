import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/screens/add_edit_todo_screen.dart';
import 'package:flutter_todo/screens/details_screen.dart';
import 'package:flutter_todo/widgets/deleted_todo_snackbar.dart';
import 'package:flutter_todo/widgets/todo_item.dart';
import 'package:uuid/uuid.dart';

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

    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<TodosBloc, TodosState>(builder: (context, state) {
        if (state is TodosLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TodosLoaded) {
          final List<Todo> todos = state.todos;
          print('${todos.length}');
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddEditScreen(
                      onSave: (todo) {
                        BlocProvider.of<TodosBloc>(context).add(
                          AddTodo(
                            Todo(
                              dateTime: DateTime.now(),
                              todo: todo,
                              id: Uuid().v4(),
                            ),
                          ),
                        );
                      },
                      isEditing: false,
                    ),
                  ),
                );
                //  RepositoryProvider.of<TodosRepository>(context).addNewTodo();
              },
              child: Icon(Icons.add),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Your Todos'),
            ),
            body: SizedBox(
              height: 300,
              child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TodoItem(
                        todo: todo,
                        onDismissed: (direction) {
                          BlocProvider.of<TodosBloc>(context)
                              .add(DeleteTodo(todo));
                          ScaffoldMessenger.of(context).showSnackBar(
                            DeleteTodoSnackBar(
                              todo: todo,
                              onUndo: () => BlocProvider.of<TodosBloc>(context)
                                  .add(AddTodo(todo)),
                            ),
                          );
                        },
                        onTap: () async {
                          final removedTodo = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) {
                              return DetailsScreen(id: todo.id);
                            }),
                          );
                          if (removedTodo != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              DeleteTodoSnackBar(
                                todo: todo,
                                onUndo: () =>
                                    BlocProvider.of<TodosBloc>(context)
                                        .add(AddTodo(todo)),
                              ),
                            );
                          }
                        },
                        onCheckboxChanged: (_) {
                          BlocProvider.of<TodosBloc>(context).add(
                            UpdateTodo(
                              todo.copyWith(completed: !todo.completed),
                            ),
                          );
                        },
                      ),

                      // Text(
                      //   '${todo[index].todo}',
                      //   style: TextStyle(fontSize: 18.0),
                      // ),
                    );
                  }),
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

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
