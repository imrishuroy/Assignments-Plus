import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_todo/repository/auth/auth_repository.dart';
import 'package:flutter_todo/screens/login/cubit/login_cubit.dart';
import 'package:flutter_todo/widgets/error_dialog.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // context.read<AuthRepository>().signOut();
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.error) {
            print('ERROR ${state.failure!.message} ');
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                content: state.failure!.message,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.grey[100],
              body: state.status == LoginStatus.submitting
                  ? Center(
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        child: Image.asset('assets/loader.gif'),
                      ),
                    )
                  : Center(
                      child: Container(
                        height: height * 0.5,
                        color: Colors.red,
                        width: width * 0.6,
                        child: Card(
                          elevation: 10.0,
                          child: Column(
                            children: [
                              Text('Assignments'),
                              SizedBox(height: 40.0),
                              Container(
                                width: 260.0,
                                height: 50.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              bottomLeft: Radius.circular(4),
                                            )),
                                        padding: EdgeInsets.zero,
                                        //  color: Colors.white,
                                        height: 50.0,
                                        width: 55.0,
                                        child: Image.asset(
                                          'assets/google.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 20.0),
                                      Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      // // Spacer(),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )

              //  Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     // crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Center(
              //         child: ElevatedButton(
              //           onPressed: () {
              //             context.read<LoginCubit>().logInWithGoogle();
              //           },
              //           child: Text('Google Sign In'),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 30.0),
              //         child: TextField(
              //           onChanged: (value) => context
              //               .read<LoginCubit>()
              //               .phoneNumberChanged(value),
              //           decoration: InputDecoration(
              //             hintText: 'Enter phone number eg-918540928489',
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: 20.0),
              //       Center(
              //         child: ElevatedButton(
              //           onPressed: () {
              //             context.read<LoginCubit>().loginWithPhone();
              //           },
              //           child: Text('Phone Sign In'),
              //         ),
              //       ),
              //     ],
              //   ),
              );
        },
      ),
    );
  }
}
