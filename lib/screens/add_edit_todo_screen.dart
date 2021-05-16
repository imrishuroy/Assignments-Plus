import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:uuid/uuid.dart';

typedef OnSaveCallback = Function(String todo);

class AddEditScreen extends StatefulWidget {
  static const String routeName = '/addTodo';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => AddEditScreen(
        onSave: (todoString) {
          BlocProvider.of<TodosBloc>(context).add(
            AddTodo(
              Todo(
                todo: todoString,
                dateTime: DateTime.now(),
                id: Uuid().v4(),
              ),
            ),
          );
        },
        isEditing: false,
      ),
    );
  }

  final bool? isEditing;
  final OnSaveCallback? onSave;
  final Todo? todo;

  AddEditScreen({
    Key? key,
    @required this.onSave,
    @required this.isEditing,
    this.todo,
  }) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _todo;

  bool get isEditing => widget.isEditing!;

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
                initialValue: isEditing ? widget.todo!.todo : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                ),
                validator: (val) {
                  return val!.trim().isEmpty ? 'Please enter some text' : null;
                },
                onSaved: (value) => _todo = value,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isEditing ? 'Save changes' : 'Add Todo',
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            widget.onSave!(_todo!);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
