import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/add-edit/add_edit_cubit.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repositories/utils/util_repository.dart';
import 'package:flutter_todo/widgets/display_image.dart';

typedef OnSaveCallback = Function(String todo, String imageUrl);

class AddEditScreen extends StatefulWidget {
  static const String routeName = '/addTodo';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<AddEditCubit>(
        create: (_) => AddEditCubit(
          utils: context.read<UtilsRepository>(),
          // RepositoryProvider.of<UtilsRepository>(context),
          todosBloc: context.read<TodosBloc>(),
          // BlocProvider.of<TodosBloc>(context),
        ),
        child: AddEditScreen(
          onSave: (todoString, imageUrl) {
            context
                .read<AddEditCubit>()
                .addEditTodo(todo: todoString, imageUrl: imageUrl);
          },

          //  (todoString, imageUrl) {
          //   BlocProvider.of<TodosBloc>(context).add(
          //     AddTodo(
          //       Todo(
          //         todo: todoString,
          //         dateTime: DateTime.now(),
          //         id: Uuid().v4(),
          //         imageUrl: imageUrl,
          //       ),
          //     ),
          //   );
          // },
          isEditing: false,
        ),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.isEditing!;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AddEditCubit, AddEditState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == AddEditStatus.submitting)
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        return Scaffold(
          // backgroundColor: Color(0xff222831),
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
                      return val!.trim().isEmpty
                          ? 'Please enter some text'
                          : null;
                    },
                    onChanged: (value) =>
                        context.read<AddEditCubit>().todoChanged(value),

                    //onSaved: (value) => _todo = value,
                  ),
                  SizedBox(height: 20.0),
                  TextButton.icon(
                    onPressed: context.read<AddEditCubit>().pickImage,
                    icon: Icon(Icons.add_a_photo),
                    label: Text('Add Image'),
                  ),
                  SizedBox(height: 20.0),
                  state.imageStatus == ImageStatus.submitting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : state.imageStatus == ImageStatus.succus
                          ? Container(
                              margin: EdgeInsets.all(10.0),
                              height: 300.0,
                              width: double.infinity,
                              child: DisplayImage(state.imageUrl!),
                              // (state.imageUrl!),
                            )
                          : Container(),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: isEditing ? 'Save changes' : 'Add Todo',
            child: Icon(
              isEditing
                  ? Icons.check
                  : context.read<AddEditCubit>().canSubmit
                      ? Icons.check
                      : Icons.add,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                print('TODO----------------- ${state.todo}');
                print('ImageUrl----------------- ${state.imageUrl}');

                // widget.onSave!(_todo!, _imageUrl!);
                widget.onSave!(state.todo!, state.imageUrl!);
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }
}
