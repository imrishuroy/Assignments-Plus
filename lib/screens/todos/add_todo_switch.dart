import 'package:assignments/blocs/public-todo/publictodo_bloc.dart';
import 'package:assignments/models/public_todos.dart';
import 'package:assignments/models/todo_model.dart';
import 'package:assignments/repositories/public-todos/public_todos_repository.dart';
import 'package:assignments/widgets/loading_indicator.dart';
import 'package:assignments/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoSwitch extends StatefulWidget {
  final String? userId;
  final Todo? todo;

  const AddTodoSwitch({
    Key? key,
    required this.userId,
    required this.todo,
  }) : super(key: key);
  @override
  _AddTodoSwitchState createState() => _AddTodoSwitchState();
}

class _AddTodoSwitchState extends State<AddTodoSwitch> {
  bool _value = false;

  Future<void> _askForDeleting(BuildContext context) async {
    try {
      var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Remove'),
            content: Text('Do you want to remove this public todo ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );

      final bool yes = await result ?? false;
      if (yes) {
        context.read<PublicTodosRepository>().deleteTodoById(widget.todo?.id);
        setState(() {
          _value = false;
        });
        ShowSnackBar.showSnackBar(context, title: 'Removed from public');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _publicTodoRepo = context.read<PublicTodosRepository>();
    return FutureBuilder<bool>(
      future: _publicTodoRepo.checkPublicTodoAlreadyExists(widget.todo?.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        }
        print('snapshot data ${snapshot.data}');

        final bool _exists = snapshot.data ?? false;
        if (_exists) {
          _value = true;
        }

        return SwitchListTile.adaptive(
          value: _value,
          title: Text('Make it public'),
          onChanged: (value) {
            setState(() {
              _value = value;
            });

            print('This is value $value');
            if (value) {
              BlocProvider.of<PublictodoBloc>(context).add(
                AddPublicTodo(
                  PublicTodo(
                    authorId: widget.userId,
                    title: widget.todo?.title,
                    todo: widget.todo?.todo,
                    dateTime: DateTime.now(),
                    todoId: widget.todo?.id,
                  ),
                ),
              );
              ShowSnackBar.showSnackBar(
                context,
                title: 'Todo added to public',
                backgroundColor: Colors.green,
              );
            } else {
              _askForDeleting(context);
            }
          },
        );
      },
    );
  }
}
