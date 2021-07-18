part of 'contactus_cubit.dart';

enum ContactUsStatus { initial, submitting, succuss, error }

class ContactusState extends Equatable {
  final String? name;
  final String? email;
  final String? message;
  final ContactUsStatus status;
  final Failure? failure;

  ContactusState(
      {required this.name,
      required this.email,
      required this.message,
      required this.status,
      required this.failure});

  factory ContactusState.initial() => ContactusState(
        email: '',
        name: '',
        message: '',
        status: ContactUsStatus.initial,
        failure: Failure(),
      );

  @override
  bool? get stringify => true;

  bool get fromValid {
    if (name != null && email != null && message != null) {
      return name!.isNotEmpty && email!.isNotEmpty && message!.isNotEmpty;
    }
    return false;
  }

  @override
  List<Object?> get props => [email, name, message, status];

  ContactusState copyWith({
    String? name,
    String? email,
    String? message,
    ContactUsStatus? status,
    Failure? failure,
  }) {
    return ContactusState(
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
