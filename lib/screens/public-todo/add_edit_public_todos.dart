import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/public-todo/publictodo_bloc.dart';

import 'package:flutter_todo/models/public_todos.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uuid/uuid.dart';

typedef OnSaveCallback = Function(
  String title,
  String todo,
  // DateTime time,
  // String authorId,
);

class AddEditPublicTodoScreen extends StatefulWidget {
  static const String routeName = '/addPublicTodo';

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => AddEditPublicTodoScreen(
        isEditing: false,
        onSave: (
          title,
          todo,
        ) {
          context.read<PublictodoBloc>().add(
                AddPublicTodo(
                  PublicTodo(
                    title: title,
                    todo: todo,
                    dateTime: DateTime.now(),
                    authorId: context.read<AuthRepository>().userId,
                    todoId: Uuid().v4(),
                  ),
                ),
              );
        },
      ),
    );
  }

  final bool? isEditing;
  final OnSaveCallback? onSave;
  final PublicTodo? todo;

  AddEditPublicTodoScreen({
    Key? key,
    @required this.onSave,
    @required this.isEditing,
    this.todo,
  }) : super(key: key);

  @override
  _AddEditPublicTodoScreenState createState() =>
      _AddEditPublicTodoScreenState();
}

class _AddEditPublicTodoScreenState extends State<AddEditPublicTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();

  bool get isEditing => widget.isEditing!;

  String? _title;
  String? _todo;

  @override
  void initState() {
    super.initState();

    if (isEditing && widget.todo != null) {
      _todoController.text = widget.todo?.todo ?? '';
      _titleController.text = widget.todo?.title ?? '';
    }
  }

  @override
  void dispose() {
    print('DISPOSE CALLED');
    _formKey.currentState?.dispose();
    if (!UniversalPlatform.isWeb) {
      ReceiveSharingIntent?.reset();
    }

    _titleController.dispose();
    _todoController.dispose();

    super.dispose();
  }

  void _addEditTodo(
    BuildContext context,
  ) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave!(_title!, _todo!);
      // widget.onSave!(
      //   _title!,
      //   _todo!,
      //   dateTime,
      //   notificationDate: notificationTime ?? dateTime,
      //   notificationId: id,
      // );

      Navigator.pop(context);
    }
  }

  final DateFormat format = DateFormat('dd MMM yy  hh:mm a');
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing ? 'Edit Todo' : 'Add Todo',
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  autofocus: !isEditing,
                  style: textTheme.headline5,
                  decoration: InputDecoration(
                    hintText: 'What needs to be done?',
                  ),
                  validator: (val) {
                    return val!.trim().isEmpty
                        ? 'Please enter some text'
                        : null;
                  },
                  onSaved: (value) => _title = value,
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  controller: _todoController,
                  onSaved: (value) => _todo = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Todo can\'t be empty' : null,
                  maxLength: 500,
                  maxLines: 11,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add your todo here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: isEditing ? 'Save changes' : 'Add Todo',
          child: Icon(isEditing ? Icons.check : Icons.add),
          onPressed: () => _addEditTodo(context),
        )
        //     : null
        // : null,
        );
  }
}

//462853618
