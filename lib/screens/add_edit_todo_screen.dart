import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';

import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/services/notification_services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:html/parser.dart' show parse;

typedef OnSaveCallback = Function(
  String title,
  String todo,
  DateTime time, {
  DateTime? notificationDate,
  int? notificationId,
});

class AddEditScreen extends StatefulWidget {
  static const String routeName = '/addTodo';

  static Route route(var arguments) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
        arguments: arguments,
      ),
      builder: (context) => AddEditScreen(
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
  //final String? sharedText;

  AddEditScreen({
    Key? key,
    @required this.onSave,
    @required this.isEditing,
    // this.sharedText,
    this.todo,
  }) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // late StreamSubscription? _intentDataStreamSubscription;
  // late StreamSubscription? _stringSubscription;
  String? _sharedText;

  bool get isEditing => widget.isEditing!;

  DateTime? notificationTime;

  String? _title;
  String? _todo;

  bool _loading = false;

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
  // String? sharedString;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        formatedTime = format.format(widget.todo!.notificationDate!);
      });
    }

    // _getSharedText();
    // _getSharedText();
  }

  // void _getSharedText() async {
  //   print('Init Runs ---------------');
  //   final String? text = ModalRoute.of(context)?.settings.arguments as String?;
  //   print('This is init state text --------------------- $text');
  //   if (text != null) {
  //     print('This is init state text --------------------- $text');
  //   }
  // }

  @override
  void didChangeDependencies() {
    print('This runssssss');
    final Map? _sharedMap = ModalRoute.of(context)?.settings.arguments as Map?;
    print('This is my shared text $_sharedMap');
    String? sharedText = _sharedMap?['sharedString'];
    // _sharedText = sha

    setState(() {
      _sharedText = sharedText;
      _title = _sharedMap?['title'];
    });

    // if (sharedText != null) {
    //   //  print('Split------------${_sharedText.split('/')}');
    //   print('this runs 1');
    //   if (sharedText.contains('http') || sharedText.contains('https')) {
    //     print('this runs 2');
    //     _getTitle(sharedText);
    //   }
    //_getHeader(_sharedText);

    super.didChangeDependencies();
  }

  // _getTitle(String url) async {
  //   var data = await MetadataFetch.extract(
  //       'https://www.freecodecamp.org/news/how-to-create-a-great-technical-course/');
  //   print('------------This is title ${data?.title}');
  //   _title = data?.title;

  //   // setState(() {
  //   //   _title = data?.title;
  //   // });
  // }

  @override
  void dispose() {
    print('DISPOSE CALLED');
    _formKey.currentState?.dispose();
    // _intentDataStreamSubscription?.cancel();
    // _sharedText = null;
    ReceiveSharingIntent.reset();
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

    // final String? _sharedText =
    //     ModalRoute.of(context)?.settings.arguments as String?;

    // CustomRouter.onGenerateRoute(settings)

    // print('THis is builder text ----------------$_sharedText');
    // print('THis is builder text ----------------${_sharedText.runtimeType}');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing ? 'Edit Todo' : 'Add Todo',
          ),
        ),
        body:

            // FutureBuilder<http.Response?>(
            //   future: http.get(Uri.parse(_sharedText.toString())),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return Center(
            //         child: Text('Something went wrong'),
            //       );
            //     }
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //     final text =
            //         snapshot.data?.statusCode == 200 ? snapshot.data?.body : null;
            //     print('------------------text $text');
            //     print('------------------text ${text.runtimeType}');

            //     // String? header = text != null ? parse(text).head.toString() : '';

            //     // print('------------------Header $header');

            //   return
            Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: TextEditingController(
                      text: isEditing ? widget.todo?.title : _title ?? ''),
                  //  text: isEditing ? widget.todo?.title : header),
                  //initialValue: isEditing ? widget.todo?.title : '',
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
                  controller: TextEditingController(
                    text: isEditing ? widget.todo?.todo : _sharedText ?? '',
                  ),
                  // text: isEditing
                  //     ? widget.todo?.todo
                  //     : _sharedText ?? ''),
                  //  initialValue: _sharedText ?? '',

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        if (isEditing && widget.todo?.notificationId != null) {
                          final notification =
                              RepositoryProvider.of<NotificationService>(
                                  context,
                                  listen: false);
                          notification
                              .cancelNotification(widget.todo!.notificationId!);
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
                            // context
                            //     .read<AddEditCubit>()
                            //     .notificationTimeChanged(date);
                            setState(() {
                              notificationTime = date;
                              formatedTime = format.format(date);
                            });
                          },
                          onConfirm: (date) {
                            // context
                            //     .read<AddEditCubit>()
                            //     .notificationTimeChanged(date);
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
                SizedBox(height: 20),
                Text('$_sharedText'),
                SizedBox(height: 20),
                Text('$_title'),
                SizedBox(height: 20),
                // Text('$sharedString'),
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
