part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, succuss, error }

class LoginState extends Equatable {
  final LoginStatus? status;
  final Failure? failure;
  final String? phoneNumber;
  final String? otp;

  const LoginState({
    @required this.status,
    @required this.failure,
    @required this.phoneNumber,
    @required this.otp,
  });

  factory LoginState.initial() {
    return LoginState(
      status: LoginStatus.initial,
      failure: Failure(),
      phoneNumber: '',
      otp: '',
    );
  }

  @override
  bool? get stringify => true;

  LoginState copyWith({
    LoginStatus? status,
    Failure? failure,
    String? phoneNumber,
    String? otp,
  }) {
    return LoginState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
    );
  }

  @override
  List<Object?> get props => [status, failure, phoneNumber, otp];
}
