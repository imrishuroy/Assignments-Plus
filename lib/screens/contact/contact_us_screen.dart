import 'package:assignments/repositories/services/firebase_service.dart';
import 'package:assignments/screens/contact/cubit/contactus_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  static const String routeName = '/contact-us';
  ContactUsScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, _, __) => BlocProvider<ContactusCubit>(
        create: (context) => ContactusCubit(
          firebaseServices: context.read<FirebaseServices>(),
        ),
        child: ContactUsScreen(),
      ),
    );
  }

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _openEmail() async {
    await launch('mailto:rishukumar.prince@gmail.com?body=Hello there !');
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();

  void _submit(BuildContext context) {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        context.read<ContactusCubit>().submit();
        _name.clear();
        _email.clear();
        _message.clear();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Something went wrong try again !',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _message.dispose();
    _email.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Contact Us'),
      ),
      body: BlocConsumer<ContactusCubit, ContactusState>(
        listener: (context, state) {
          if (state.status == ContactUsStatus.succuss) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Message sent, Thanks for contacting us we will soon reach out to you !',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 25.0,
                  ),
                  child: Text(
                    _contactNote,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _openEmail();
                  },
                  icon: Icon(Icons.mail),
                  label: Text('EMAIL US'),
                ),
                SizedBox(height: 20.0),
                Text(
                  'or',
                  style: TextStyle(fontSize: 17.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Card(
                    child: Container(
                      width: 600.0,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 40.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 10.0),
                              TextFormField(
                                controller: _name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name can\t be empty';
                                  }
                                  return null;
                                },
                                onChanged: (value) => context
                                    .read<ContactusCubit>()
                                    .nameChanged(value),
                                decoration: InputDecoration(
                                  hintText: 'Please enter your name eg, Rishu',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      4.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              TextFormField(
                                controller: _email,
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty && value.contains('@')) {
                                      return 'Invalid email address ';
                                    }
                                  }
                                  return null;
                                },
                                onChanged: (value) => context
                                    .read<ContactusCubit>()
                                    .emailChanged(value),
                                decoration: InputDecoration(
                                  hintText:
                                      'Please enter your email eg, rishu@gmailcom',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      4.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              TextFormField(
                                controller: _message,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (value) => context
                                    .read<ContactusCubit>()
                                    .messageChanged(value),
                                maxLength: 1000,
                                maxLines: 8,
                                minLines: 4,
                                decoration: InputDecoration(
                                  hintText:
                                      'Please enter your query, suggestions or feedback',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      4.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              SizedBox(
                                height: 40.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _submit(context);
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                // Row(children: [
                //   Text('Made with'),

                // ],)
                Text(
                  'Made with ❤️ by Assignment team',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 7.0),
                Text(
                  '© sixteenbrains.com',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          );
        },
      ),
    );
  }
}

const String _contactNote =
    'Hello there, we are very thankful for your love and support and eagerly waiting to hear more from you. If you have any query, suggestions or feedback, please feel free to contact us, and we will be more than happy to help you.';
