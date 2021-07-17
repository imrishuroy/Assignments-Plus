import 'package:assignments/blocs/public-todo/publictodo_bloc.dart';
import 'package:assignments/models/public_todos.dart';
import 'package:assignments/screens/public-todo/add_edit_public_todos.dart';
import 'package:assignments/screens/public-todo/public_todos.details.dart';
import 'package:assignments/screens/public-todo/widgets/public_todo_item.dart';
import 'package:assignments/widgets/deleted_todo_snackbar.dart';
import 'package:assignments/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PublicTodos extends StatelessWidget {
  PublicTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddEditPublicTodoScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            child: BlocBuilder<PublictodoBloc, PublictodoState>(
              builder: (context, state) {
                if (state is PublictodoLoading) {
                  return const Center(
                    // child: CircularProgressIndicator(),
                    child: const LoadingIndicator(),
                  );
                } else if (state is PublicTodosLoaded) {
                  final todos = state.todos;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final PublicTodo publicTodo = todos[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: PublicTodoItem(
                              todo: publicTodo,
                              onTap: () async {
                                final removedTodo =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PublicTodoDetailsScreen(
                                      id: publicTodo.todoId,
                                    ),
                                  ),
                                );
                                if (removedTodo != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    DeleteTodoSnackBar(
                                      title: publicTodo.title,
                                      onUndo: () =>
                                          BlocProvider.of<PublictodoBloc>(
                                                  context)
                                              .add(AddPublicTodo(publicTodo)),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
