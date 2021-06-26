import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/add-edit/add_edit_cubit.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/services/notification_services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

typedef OnSaveCallback = Function(
  String title,
  String todo,
  DateTime time, {
  DateTime? notificationDate,
  int? notificationId,
});

class AddEditScreen extends StatefulWidget {
  static const String routeName = '/addTodo';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<AddEditCubit>(
        create: (_) => AddEditCubit(
          todosBloc: context.read<TodosBloc>(),
        ),
        child: AddEditScreen(
          onSave: (
            title,
            todoString,
            time, {
            DateTime? notificationDate,
            int? notificationId,
          }) {
            context.read<AddEditCubit>().addEditTodo(
                  title: title,
                  todo: todoString,
                  dateTime: time,
                  notificationDate: notificationDate,
                  notificationId: notificationId,
                );
          },
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
  }

  @override
  void dispose() {
    print('DISPOSE CALLED');
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _addEditTodo(BuildContext context, AddEditState state) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final DateTime dateTime = DateTime.now();
      final id = dateTime.hour + dateTime.millisecond + dateTime.day;
      widget.onSave!(
        state.title!,
        state.todo!,
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
          message: state.title!,
          channelId: dateTime.toString(),
          channelName: dateTime.toString(),
          channelDescription: state.title!,
        );
      }

      Navigator.pop(context);
    }
  }

  final DateFormat format = DateFormat('dd MMM yy  hh:mm a');
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
                      onSaved: (value) {
                        print(value);
                        context.read<AddEditCubit>().titleChanged(value!);
                      },
                      onChanged: (value) =>
                          context.read<AddEditCubit>().titleChanged(value),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      initialValue: isEditing ? widget.todo?.todo : '',
                      onSaved: (value) {
                        print(value);
                        context.read<AddEditCubit>().todoChanged(value!);
                      },
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
                                context
                                    .read<AddEditCubit>()
                                    .notificationTimeChanged(date);
                                setState(() {
                                  notificationTime = date;
                                  formatedTime = format.format(date);
                                });
                              },
                              onConfirm: (date) {
                                context
                                    .read<AddEditCubit>()
                                    .notificationTimeChanged(date);
                                print('confirm $date');
                                if (date != notificationTime) {
                                  setState(() {
                                    notificationTime = date;
                                    formatedTime = format.format(date);
                                  });
                                }
                              },
                              // locale: LocaleType.ar,
                            );
                          },
                          icon: Icon(
                            Icons.notification_add,
                          ),
                          label: Text(
                            isEditing
                                ? 'Edit Notification'
                                : 'Set Notification',
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
              child: Icon(
                isEditing
                    ? Icons.check
                    : context.read<AddEditCubit>().canSubmit
                        ? Icons.check
                        // : Icons.add,
                        : Icons.check,
              ),
              onPressed: () => _addEditTodo(context, state),
            )
            //     : null
            // : null,
            );
      },
    );
  }
}

//462853618