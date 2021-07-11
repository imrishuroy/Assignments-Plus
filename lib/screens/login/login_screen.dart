import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';

import 'package:flutter_todo/screens/login/cubit/login_cubit.dart';
import 'package:flutter_todo/widgets/error_dialog.dart';
import 'package:flutter_todo/widgets/loading_indicator.dart';

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
          print('Width - $width');
          //print("Height - $height");
          return Scaffold(
            //backgroundColor: Color(0xff8d93ab),

            // backgroundColor: Colors.grey[100],
            body: state.status == LoginStatus.submitting
                ? Center(
                    child: LoadingIndicator(),
                  )
                : Center(
                    child: Container(
                      height: height * 0.5,
                      //color: Colors.red,
                      width: width * 0.9,
                      child: Card(
                        elevation: 10.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '+ Assignments',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              width: 250.0,
                              height: 50.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  context.read<LoginCubit>().logInWithGoogle();
                                },
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
                                        ),
                                      ),
                                      padding: EdgeInsets.zero,
                                      height: 50.0,
                                      width: 50.0,
                                      child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        child: SvgPicture.asset(
                                          'assets/google.svg',
                                          fit: BoxFit.contain,
                                          height: 20.0,
                                          width: 20.0,
                                          // fit: BoxFit.contain,

                                          // fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 20.0),
                                    Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontSize: width < 900 ? 18 : 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // // Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  '" Don\'t be a minimum guy "',
                                  style: TextStyle(
                                    fontSize: width < 900 ? 16.0 : 20.0,
                                    letterSpacing: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
