import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';

import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/services/notification_services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uuid/uuid.dart';

typedef OnSaveCallback = Function(
  String title,
  String todo,
  DateTime time, {
  DateTime? notificationDate,
  int? notificationId,
});

class AddEditTodoScreen extends StatefulWidget {
  static const String routeName = '/addTodo';

  static Route route(var arguments) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
        arguments: arguments,
      ),
      builder: (context) => AddEditTodoScreen(
        isEditing: false,
        onSave: (
          title,
          todoString,
          time, {
          DateTime? notificationDate,
          int? notificationId,
        }) {
          context.read<TodosBloc>().add(
                AddTodo(
                  Todo(
                    id: Uuid().v4(),
                    title: title,
                    todo: todoString,
                    dateTime: time,
                    notificationId: notificationId,
                    notificationDate: notificationDate,
                  ),
                ),
              );
        },
      ),
    );
  }

  final bool? isEditing;
  final OnSaveCallback? onSave;
  final Todo? todo;

  AddEditTodoScreen({
    Key? key,
    @required this.onSave,
    @required this.isEditing,
    this.todo,
  }) : super(key: key);

  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();

  bool get isEditing => widget.isEditing!;

  DateTime? notificationTime;

  String? _title;
  String? _todo;

  void setNotification({
    required BuildContext context,
    required DateTime time,
    required String channelId,
    required String channelName,
    required String channelDescription,
    required int id,
    required String title,
    required String message,
  }) {
    final notification =
        RepositoryProvider.of<NotificationService>(context, listen: false);

    notification.sheduledNotification(
      time: time,
      channelId: '$channelId',
      channelName: '$channelName',
      channelDescription: '$channelDescription',
      id: id,
      title: '$title',
      message: '$message',
    );
  }

  String? formatedTime;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        formatedTime = format.format(widget.todo!.notificationDate!);
      });
    }
    if (isEditing && widget.todo != null) {
      _todoController.text = widget.todo?.todo ?? '';
      _titleController.text = widget.todo?.title ?? '';
    }
  }

  @override
  void didChangeDependencies() {
    final Map? _sharedMap = ModalRoute.of(context)?.settings.arguments as Map?;
    print('This is my shared text $_sharedMap');
    if (_sharedMap != null) {
      _titleController.text = _sharedMap['title'] ?? '';
      _todoController.text = _sharedMap['sharedString'] ?? '';
    }
    super.didChangeDependencies();
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
      final DateTime dateTime = DateTime.now();
      final id = dateTime.hour + dateTime.millisecond + dateTime.day;
      widget.onSave!(
        _title!,
        _todo!,
        dateTime,
        notificationDate: notificationTime ?? dateTime,
        notificationId: id,
      );
      if (notificationTime != null) {
        setNotification(
          context: context,
          time: notificationTime!,
          id: id,
          title: 'Reminder',
          message: _title!,
          channelId: dateTime.toString(),
          channelName: dateTime.toString(),
          channelDescription: _title!,
        );
      }

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
                SizedBox(height: 10.0),
                if (!UniversalPlatform.isWeb)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          if (isEditing &&
                              widget.todo?.notificationId != null) {
                            final notification =
                                RepositoryProvider.of<NotificationService>(
                                    context,
                                    listen: false);
                            notification.cancelNotification(
                                widget.todo!.notificationId!);
                          }

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
                                formatedTime = format.format(date);
                              });
                            },
                            onConfirm: (date) {
                              print('confirm $date');
                              if (date != notificationTime) {
                                setState(() {
                                  notificationTime = date;
                                  formatedTime = format.format(date);
                                });
                              }
                            },
                          );
                        },
                        icon: Icon(
                          Icons.notification_add,
                        ),
                        label: Text(
                          isEditing ? 'Edit Notification' : 'Set Notification',
                        ),
                      ),
                      if (formatedTime != null ||
                          widget.todo?.notificationDate != null)
                        Stack(
                          children: [
                            Chip(
                              label: Text(
                                '${formatedTime ?? ''}',
                              ),
                            ),
                            Positioned(
                              right: -1.7,
                              top: -1.7,
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 19.0,
                              ),
                            )
                          ],
                        ),
                    ],
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
