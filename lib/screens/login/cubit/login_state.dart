part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, succuss, error }

class LoginState extends Equatable {
  final LoginStatus? status;
  final Failure? failure;

  const LoginState({
    @required this.status,
    @required this.failure,
  });

  factory LoginState.initial() {
    return LoginState(
      status: LoginStatus.initial,
      failure: Failure(),
    );
  }

  @override
  bool? get stringify => true;

  LoginState copyWith({
    LoginStatus? status,
    Failure? failure,
  }) {
    return LoginState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, failure];
}
