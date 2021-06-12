import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/add-edit/add_edit_cubit.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repositories/utils/util_repository.dart';
import 'package:flutter_todo/services/notification_services.dart';
import 'package:flutter_todo/widgets/display_image.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

typedef OnSaveCallback = Function(String title, String todo, String imageUrl);

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
          onSave: (title, todoString, imageUrl) {
            context.read<AddEditCubit>().addEditTodo(
                  title: title,
                  todo: todoString,
                  imageUrl: imageUrl,
                );
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

  DateTime? notificationTime;

  void setNotification(BuildContext context, DateTime time) {
    final notification =
        RepositoryProvider.of<NotificationService>(context, listen: false);

    notification.sheduledNotification(
      time: time,
      channelId: '5',
      channelName: '5 sec channel',
      channelDescription: 'this will display notification of 5 sec',
      id: 0,
      title: 'Hi there...',
      message: 'This is 5 sec notification',
    );
  }

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
                      initialValue: isEditing ? widget.todo?.title : '',
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
                      onSaved: (value) =>
                          context.read<AddEditCubit>().titleChanged(value!),
                      onChanged: (value) =>
                          context.read<AddEditCubit>().titleChanged(value),

                      //onSaved: (value) => _todo = value,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      initialValue: isEditing ? widget.todo?.todo : '',
                      onSaved: (value) =>
                          context.read<AddEditCubit>().todoChanged(value!),
                      onChanged: (value) =>
                          context.read<AddEditCubit>().todoChanged(value),
                      maxLength: 500,
                      maxLines: 11,
                      minLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add your todo here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: context.read<AddEditCubit>().pickImage,
                          icon: Icon(Icons.add_a_photo),
                          label: Text('Add Image'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // DatePicker.showTime12hPicker(context,
                            //     showTitleActions: true, onChanged: (date) {
                            //   print('change $date in time zone ' +
                            //       date.timeZoneOffset.inHours.toString());
                            // }, onConfirm: (date) {
                            //   print('confirm $date');
                            // }, currentTime: DateTime.now());

                            DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              theme: DatePickerTheme(),
                              minTime: DateTime.now(),
                              maxTime: DateTime(2022, 1, 1, 00, 00),
                              onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());

                                setState(() {
                                  notificationTime = date;
                                });
                              },
                              onConfirm: (date) {
                                print('confirm $date');
                              },
                              // locale: LocaleType.ar,
                            );
                          },
                          icon: Icon(Icons.notification_add),
                          label: Text('Set Notification'),
                        )
                      ],
                    ),
                    //SizedBox(height: 10.0),
                    state.imageStatus == ImageStatus.submitting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : state.imageStatus == ImageStatus.succus
                            ? Container(
                                height: 250.0,
                                width: double.infinity,
                                child: DisplayImage(state.imageUrl!),
                                // (state.imageUrl!),
                              )
                            : Container(),
                  ],
                ),
              ),
            ),
            // floatingActionButton: state.todo!.isNotEmpty
            floatingActionButton:
                // isEditing
                //     ? widget.todo!.title.isNotEmpty
                //         ?
                FloatingActionButton(
              tooltip: isEditing ? 'Save changes' : 'Add Todo',
              child: Icon(
                isEditing
                    ? Icons.check
                    : context.read<AddEditCubit>().canSubmit
                        ? Icons.check
                        // : Icons.add,
                        : Icons.check,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print('TODO----------------- ${state.todo}');
                  print('ImageUrl----------------- ${state.imageUrl}');

                  // widget.onSave!(_todo!, _imageUrl!);
                  widget.onSave!(state.title!, state.todo!, state.imageUrl!);
                  if (notificationTime != null) {
                    setNotification(context, notificationTime!);
                  }

                  Navigator.pop(context);
                }
              },
            )
            //     : null
            // : null,
            );
      },
    );
  }
}
